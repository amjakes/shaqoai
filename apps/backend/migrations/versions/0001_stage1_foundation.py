"""Stage 1 workspace-scoped foundation."""
from alembic import op
import sqlalchemy as sa
from pgvector.sqlalchemy import Vector

revision = "0001_stage1_foundation"
down_revision = None
branch_labels = None
depends_on = None


def scoped_columns():
    return [
        sa.Column("id", sa.UUID(), primary_key=True),
        sa.Column("workspace_id", sa.UUID(), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False, index=True),
    ]


def timestamps():
    return [
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    ]


def upgrade() -> None:
    op.execute("CREATE EXTENSION IF NOT EXISTS vector")
    role = sa.Enum("owner", "admin", "manager", "member", "viewer", name="workspace_role")
    approval_status = sa.Enum("pending", "approved", "rejected", name="approval_status")
    role.create(op.get_bind(), checkfirst=True)
    approval_status.create(op.get_bind(), checkfirst=True)
    op.create_table("users", sa.Column("id", sa.UUID(), primary_key=True), sa.Column("email", sa.String(320), nullable=False), sa.Column("password_hash", sa.String(255)), sa.Column("display_name", sa.String(120), nullable=False), sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()), *timestamps())
    op.create_index("ix_users_email", "users", ["email"], unique=True)
    op.create_table("workspaces", sa.Column("id", sa.UUID(), primary_key=True), sa.Column("name", sa.String(160), nullable=False), sa.Column("slug", sa.String(160), nullable=False), *timestamps())
    op.create_index("ix_workspaces_slug", "workspaces", ["slug"], unique=True)
    op.create_table("workspace_memberships", sa.Column("id", sa.UUID(), primary_key=True), sa.Column("workspace_id", sa.UUID(), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False), sa.Column("user_id", sa.UUID(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False), sa.Column("role", role, nullable=False), *timestamps(), sa.UniqueConstraint("workspace_id", "user_id", name="uq_workspace_member"))
    op.create_index("ix_workspace_memberships_workspace_id", "workspace_memberships", ["workspace_id"])
    op.create_index("ix_workspace_memberships_user_id", "workspace_memberships", ["user_id"])
    op.create_table("agents", *scoped_columns(), sa.Column("name", sa.String(160), nullable=False), sa.Column("kind", sa.String(80), nullable=False), sa.Column("policy", sa.JSON(), nullable=False), sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()), *timestamps())
    op.create_table("conversations", *scoped_columns(), sa.Column("channel", sa.String(60), nullable=False), sa.Column("external_id", sa.String(255)), sa.Column("summary", sa.Text()), *timestamps())
    op.create_table("tasks", *scoped_columns(), sa.Column("agent_id", sa.UUID(), sa.ForeignKey("agents.id", ondelete="SET NULL")), sa.Column("idempotency_key", sa.String(255), nullable=False), sa.Column("status", sa.String(40), nullable=False), sa.Column("payload", sa.JSON(), nullable=False), sa.Column("run_budget_cents", sa.Integer(), nullable=False), *timestamps(), sa.UniqueConstraint("workspace_id", "idempotency_key", name="uq_task_workspace_idempotency"))
    op.create_table("approvals", *scoped_columns(), sa.Column("task_id", sa.UUID(), sa.ForeignKey("tasks.id", ondelete="SET NULL")), sa.Column("status", approval_status, nullable=False), sa.Column("risk_level", sa.String(30), nullable=False), sa.Column("requested_action", sa.JSON(), nullable=False), sa.Column("decided_by", sa.UUID(), sa.ForeignKey("users.id", ondelete="SET NULL")), sa.Column("decided_at", sa.DateTime(timezone=True)), *timestamps())
    op.create_table("audit_logs", sa.Column("id", sa.UUID(), primary_key=True), sa.Column("workspace_id", sa.UUID(), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False, index=True), sa.Column("actor_id", sa.UUID(), sa.ForeignKey("users.id", ondelete="SET NULL")), sa.Column("event_type", sa.String(100), nullable=False), sa.Column("metadata_json", sa.JSON(), nullable=False), sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False))
    op.create_table("knowledge_documents", *scoped_columns(), sa.Column("source_name", sa.String(255), nullable=False), sa.Column("content", sa.Text(), nullable=False), sa.Column("embedding", Vector(1536)), *timestamps())


def downgrade() -> None:
    for table in ["knowledge_documents", "audit_logs", "approvals", "tasks", "conversations", "agents", "workspace_memberships", "workspaces", "users"]:
        op.drop_table(table)
    sa.Enum(name="approval_status").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="workspace_role").drop(op.get_bind(), checkfirst=True)
