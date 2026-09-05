"""WhatsApp Cloud API parsing and authentication primitives.

This module deliberately performs no database or agent work.  The webhook
handler authenticates and persists an event before the worker receives it.
"""
from __future__ import annotations

import hashlib
import hmac
from dataclasses import dataclass
from typing import Any, Iterable


@dataclass(frozen=True)
class InboundWhatsAppMessage:
    event_id: str
    phone_number_id: str
    sender: str
    text: str
    raw: dict[str, Any]


def verify_signature(raw_body: bytes, signature: str | None, app_secret: str | None) -> bool:
    """Validate Meta's X-Hub-Signature-256 header in constant time."""
    if not app_secret or not signature or not signature.startswith("sha256="):
        return False
    expected = "sha256=" + hmac.new(app_secret.encode(), raw_body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, signature)


def verify_challenge(mode: str | None, token: str | None, challenge: str | None, verify_token: str | None) -> str | None:
    if mode != "subscribe" or not challenge or not token or not verify_token:
        return None
    return challenge if hmac.compare_digest(token, verify_token) else None


def inbound_messages(payload: dict[str, Any]) -> Iterable[InboundWhatsAppMessage]:
    """Yield only text messages; delivery receipts are intentionally ignored."""
    for entry in payload.get("entry", []):
        for change in entry.get("changes", []):
            value = change.get("value", {})
            phone_number_id = str(value.get("metadata", {}).get("phone_number_id", ""))
            for message in value.get("messages", []):
                if message.get("type") != "text":
                    continue
                event_id, sender = message.get("id"), message.get("from")
                text = message.get("text", {}).get("body", "").strip()
                if event_id and sender and phone_number_id and text:
                    yield InboundWhatsAppMessage(str(event_id), phone_number_id, str(sender), text, message)
