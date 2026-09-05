"""Add workspace RAG and immutable agent run evidence.

Revision ID: 0003_rag_and_audit
Revises: 0002_whatsapp_support
"""
from alembic import op
import sqlalchemy as sa
from pgvector.sqlalchemy import Vector
from sqlalchemy.dialects import postgresql

revision = "0003_rag_and_audit"
down_revision = "0002_whatsapp_support"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "knowledge_sources",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("name", sa.String(255), nullable=False), sa.Column("source_type", sa.String(40), nullable=False, server_default="text"),
        sa.Column("content_hash", sa.String(64), nullable=False), sa.Column("created_by", postgresql.UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="SET NULL")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()), sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.UniqueConstraint("workspace_id", "content_hash", name="uq_knowledge_source_content"),
    )
    op.create_index("ix_knowledge_sources_workspace_id", "knowledge_sources", ["workspace_id"])
    op.create_table(
        "knowledge_chunks",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True), sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("source_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("knowledge_sources.id", ondelete="CASCADE"), nullable=False), sa.Column("chunk_index", sa.Integer(), nullable=False), sa.Column("content", sa.Text(), nullable=False), sa.Column("embedding", Vector(1536), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()), sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.UniqueConstraint("source_id", "chunk_index", name="uq_knowledge_chunk_position"),
    )
    op.create_index("ix_knowledge_chunks_workspace_id", "knowledge_chunks", ["workspace_id"])
    op.create_index("ix_knowledge_chunks_source_id", "knowledge_chunks", ["source_id"])
    op.create_table(
        "agent_run_audits",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True), sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False), sa.Column("actor_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("users.id", ondelete="SET NULL")),
        sa.Column("run_id", sa.String(255), nullable=False), sa.Column("prompt_version", sa.String(100), nullable=False), sa.Column("retrieved_sources", sa.JSON(), nullable=False), sa.Column("tools_called", sa.JSON(), nullable=False), sa.Column("tool_parameters", sa.JSON(), nullable=False), sa.Column("approval_decision", sa.JSON(), nullable=False), sa.Column("outcome", sa.String(60), nullable=False), sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_agent_run_audits_workspace_id", "agent_run_audits", ["workspace_id"])
    op.create_index("ix_agent_run_audits_run_id", "agent_run_audits", ["run_id"])
    op.execute("""CREATE FUNCTION prevent_audit_mutation() RETURNS trigger AS $$ BEGIN RAISE EXCEPTION 'Audit records are immutable'; END; $$ LANGUAGE plpgsql;""")
    for table in ("audit_logs", "agent_run_audits"):
        op.execute(f"CREATE TRIGGER {table}_immutable BEFORE UPDATE OR DELETE ON {table} FOR EACH ROW EXECUTE FUNCTION prevent_audit_mutation();")


def downgrade() -> None:
    for table in ("audit_logs", "agent_run_audits"):
        op.execute(f"DROP TRIGGER {table}_immutable ON {table};")
    op.execute("DROP FUNCTION prevent_audit_mutation();")
    op.drop_index("ix_agent_run_audits_run_id", table_name="agent_run_audits")
    op.drop_index("ix_agent_run_audits_workspace_id", table_name="agent_run_audits")
    op.drop_table("agent_run_audits")
    op.drop_index("ix_knowledge_chunks_source_id", table_name="knowledge_chunks")
    op.drop_index("ix_knowledge_chunks_workspace_id", table_name="knowledge_chunks")
    op.drop_table("knowledge_chunks")
    op.drop_index("ix_knowledge_sources_workspace_id", table_name="knowledge_sources")
    op.drop_table("knowledge_sources")
