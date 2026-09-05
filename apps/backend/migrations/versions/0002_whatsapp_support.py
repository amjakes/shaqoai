"""Add WhatsApp support workflow persistence.

Revision ID: 0002_whatsapp_support
Revises: 0001_stage1_foundation
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision = "0002_whatsapp_support"
down_revision = "0001_stage1_foundation"
branch_labels = None
depends_on = None


def upgrade() -> None:
    consent = postgresql.ENUM("opted_in", "opted_out", name="consent_status", create_type=False)
    consent.create(op.get_bind(), checkfirst=True)
    op.add_column("conversations", sa.Column("consent_status", consent, nullable=False, server_default="opted_in"))
    op.create_table(
        "whatsapp_channels",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("phone_number_id", sa.String(length=128), nullable=False, unique=True),
        sa.Column("display_name", sa.String(length=120), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_whatsapp_channels_workspace_id", "whatsapp_channels", ["workspace_id"])
    op.create_table(
        "whatsapp_events",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("event_id", sa.String(length=255), nullable=False, unique=True),
        sa.Column("channel_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("whatsapp_channels.id", ondelete="CASCADE"), nullable=False),
        sa.Column("conversation_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("conversations.id", ondelete="SET NULL")),
        sa.Column("sender", sa.String(length=64), nullable=False),
        sa.Column("message_text", sa.Text(), nullable=False),
        sa.Column("event_type", sa.String(length=40), nullable=False, server_default="inbound"),
        sa.Column("delivery_status", sa.String(length=40), nullable=False, server_default="received"),
        sa.Column("failure_count", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("raw_payload", sa.JSON(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )
    for column in ("workspace_id", "channel_id", "conversation_id", "sender"):
        op.create_index(f"ix_whatsapp_events_{column}", "whatsapp_events", [column])


def downgrade() -> None:
    for column in ("sender", "conversation_id", "channel_id", "workspace_id"):
        op.drop_index(f"ix_whatsapp_events_{column}", table_name="whatsapp_events")
    op.drop_table("whatsapp_events")
    op.drop_index("ix_whatsapp_channels_workspace_id", table_name="whatsapp_channels")
    op.drop_table("whatsapp_channels")
    op.drop_column("conversations", "consent_status")
    postgresql.ENUM(name="consent_status").drop(op.get_bind(), checkfirst=True)
