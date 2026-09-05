from celery import Celery

from .config import get_settings

celery_app = Celery("shaqoai", broker=get_settings().redis_url, backend=get_settings().redis_url)
celery_app.conf.update(task_serializer="json", result_serializer="json", accept_content=["json"], task_track_started=True, task_time_limit=300)


@celery_app.task(bind=True, autoretry_for=(ConnectionError,), retry_backoff=True, max_retries=3)
def process_workspace_task(self, workspace_id: str, task_id: str) -> dict[str, str]:
    """Stage-1 queue boundary. Future agent DAG execution must enter here with an idempotency key."""
    return {"workspace_id": workspace_id, "task_id": task_id, "status": "queued"}
