import uuid

import httpx
from celery import Celery
from sqlalchemy import select

from .config import get_settings

celery_app = Celery("shaqoai", broker=get_settings().redis_url, backend=get_settings().redis_url)
celery_app.conf.update(task_serializer="json", result_serializer="json", accept_content=["json"], task_track_started=True, task_time_limit=300)


@celery_app.task(bind=True, autoretry_for=(ConnectionError,), retry_backoff=True, max_retries=3)
def process_workspace_task(self, workspace_id: str, task_id: str) -> dict[str, str]:
    """Stage-1 queue boundary. Future agent DAG execution must enter here with an idempotency key."""
    return {"workspace_id": workspace_id, "task_id": task_id, "status": "queued"}


@celery_app.task(bind=True, autoretry_for=(httpx.HTTPError,), retry_backoff=True, retry_jitter=True, max_retries=3)
def process_whatsapp_event(self, event_id: str) -> dict[str, str]:
    """Idempotent background boundary for the one-message support DAG."""
    from .database import SessionLocal
    from .audit import record_agent_run
    from .models import AuditLog, ConsentStatus, Conversation, Task, WhatsAppChannel, WhatsAppEvent
    from .prompt_security import appears_injected
    from .rag import retrieve
    from .support_workflow import is_sensitive, route_message

    with SessionLocal() as db:
        event = db.get(WhatsAppEvent, uuid.UUID(event_id))
        if event is None or event.delivery_status in {"processed", "opted_out", "escalated"}:
            return {"event_id": event_id, "status": "already_processed"}
        channel = db.get(WhatsAppChannel, event.channel_id)
        conversation = db.scalar(select(Conversation).where(Conversation.workspace_id == event.workspace_id, Conversation.external_id == f"wa:{event.channel_id}:{event.sender}"))
        if conversation is None:
            conversation = Conversation(workspace_id=event.workspace_id, channel="whatsapp", external_id=f"wa:{event.channel_id}:{event.sender}")
            db.add(conversation)
            db.flush()
        event.conversation_id = conversation.id
        try:
            sources = [] if appears_injected(event.message_text) or is_sensitive(event.message_text) else retrieve(db, event.workspace_id, event.message_text)
        except Exception:
            sources = []  # A retrieval outage fails closed into the human-review route.
        decision = route_message(event.message_text, sources)
        record_agent_run(
            db,
            workspace_id=event.workspace_id,
            run_id=event.event_id,
            prompt_version="support-v2-rag-boundary",
            outcome=decision.outcome,
            sources=sources,
            tools_called=["knowledge_retrieval"] if sources else [],
            tool_parameters={"top_k": 5},
            approval_decision={"human_review_required": decision.outcome == "escalate", "reason": decision.reason},
        )
        if decision.outcome == "opt_out":
            conversation.consent_status = ConsentStatus.opted_out
        elif decision.outcome == "opt_in":
            conversation.consent_status = ConsentStatus.opted_in
        elif conversation.consent_status == ConsentStatus.opted_out:
            event.delivery_status = "opted_out"
            db.commit()
            return {"event_id": event_id, "status": "suppressed_by_consent"}
        if decision.outcome == "escalate":
            task = Task(workspace_id=event.workspace_id, idempotency_key=f"support-escalation:{event.event_id}", status="requires_human_review", payload={"conversation_id": str(conversation.id), "reason": decision.reason, "message": event.message_text}, run_budget_cents=0)
            db.add(task)
            event.delivery_status = "escalated"
            db.add(AuditLog(workspace_id=event.workspace_id, actor_id=None, event_type="support.escalated", metadata_json={"event_id": event.event_id, "reason": decision.reason}))
            db.commit()
            return {"event_id": event_id, "status": "escalated"}
        if not channel or not channel.is_active:
            event.delivery_status = "delivery_failed"
            event.failure_count += 1
            db.commit()
            return {"event_id": event_id, "status": "channel_inactive"}
        settings = get_settings()
        if not settings.whatsapp_access_token:
            raise httpx.RequestError("WhatsApp access token is not configured")
        try:
            response = httpx.post(
                f"https://graph.facebook.com/{settings.whatsapp_graph_version}/{channel.phone_number_id}/messages",
                headers={"Authorization": f"Bearer {settings.whatsapp_access_token}"},
                json={"messaging_product": "whatsapp", "to": event.sender, "type": "text", "text": {"body": decision.reply}},
                timeout=15,
            )
            response.raise_for_status()
        except httpx.HTTPError:
            event.failure_count += 1
            event.delivery_status = "retrying"
            db.commit()
            raise
        conversation.summary = decision.reply
        event.delivery_status = "processed"
        db.add(AuditLog(workspace_id=event.workspace_id, actor_id=None, event_type="support.reply_sent", metadata_json={"event_id": event.event_id, "reason": decision.reason}))
        db.commit()
        return {"event_id": event_id, "status": "processed"}
