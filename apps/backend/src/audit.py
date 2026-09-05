"""One write path for evidence required to reproduce and review agent work."""
from __future__ import annotations

import uuid

from sqlalchemy.orm import Session

from .models import AgentRunAudit
from .rag import Citation


def record_agent_run(
    db: Session,
    *,
    workspace_id: uuid.UUID,
    run_id: str,
    prompt_version: str,
    outcome: str,
    actor_id: uuid.UUID | None = None,
    sources: list[Citation] | None = None,
    tools_called: list[str] | None = None,
    tool_parameters: dict | None = None,
    approval_decision: dict | None = None,
) -> None:
    db.add(AgentRunAudit(
        workspace_id=workspace_id,
        actor_id=actor_id,
        run_id=run_id,
        prompt_version=prompt_version,
        outcome=outcome,
        retrieved_sources=[{"source_id": str(source.source_id), "source_name": source.source_name, "chunk_index": source.chunk_index} for source in sources or []],
        tools_called=tools_called or [],
        tool_parameters=tool_parameters or {},
        approval_decision=approval_decision or {},
    ))
