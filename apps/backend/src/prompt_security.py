"""Treat every user and retrieved string as data, never executable instructions."""
from __future__ import annotations

import re

INJECTION_PATTERN = re.compile(
    r"\b(ignore|disregard|override|reveal|print|repeat)\b.{0,80}\b(instruction|system|prompt|policy|developer)\b|\b(system prompt|jailbreak|act as)\b",
    re.IGNORECASE | re.DOTALL,
)


def appears_injected(content: str) -> bool:
    return bool(INJECTION_PATTERN.search(content))


def untrusted_block(label: str, content: str) -> str:
    """Delimited data block, suitable only for a user-content model message."""
    return f"<UNTRUSTED_{label}>\n{content}\n</UNTRUSTED_{label}>"
