"""Bounded support workflow: classify once, never execute customer actions."""
from __future__ import annotations

import json
import re
from dataclasses import dataclass

from openai import OpenAI

from .config import get_settings

MAX_MODEL_CALLS_PER_RUN = 1
MAX_OUTPUT_TOKENS = 180
CONFIDENCE_THRESHOLD = 0.80
SAFE_INTENTS = {"faq", "product_information", "business_hours"}
SENSITIVE_PATTERN = re.compile(r"\b(payment|mpesa|m-pesa|refund|password|login|account|invoice|bank|legal|medical|delete|cancel|complaint|personal data)\b", re.I)
OPT_OUT_WORDS = {"stop", "unsubscribe", "end", "quit", "cancel"}
OPT_IN_WORDS = {"start", "unstop", "subscribe"}


@dataclass(frozen=True)
class RoutingDecision:
    outcome: str  # reply, escalate, opt_in, opt_out
    reason: str
    reply: str | None = None


def consent_command(text: str) -> str | None:
    normalized = text.strip().casefold()
    if normalized in OPT_OUT_WORDS:
        return "opt_out"
    if normalized in OPT_IN_WORDS:
        return "opt_in"
    return None


def route_message(text: str) -> RoutingDecision:
    """Return a policy-bound result. Model output can never override risk rules."""
    command = consent_command(text)
    if command == "opt_out":
        return RoutingDecision("opt_out", "customer_opt_out", "You have been unsubscribed. Reply START at any time to opt in again.")
    if command == "opt_in":
        return RoutingDecision("opt_in", "customer_opt_in", "You are subscribed again. How can our support team help?")
    if SENSITIVE_PATTERN.search(text):
        return RoutingDecision("escalate", "sensitive_or_transactional_request")

    settings = get_settings()
    if not settings.openai_api_key:
        return RoutingDecision("escalate", "model_not_configured")
    try:
        result = OpenAI(api_key=settings.openai_api_key).responses.create(
            model=settings.support_model,
            max_output_tokens=MAX_OUTPUT_TOKENS,
            input=[{"role": "system", "content": "You are a narrow FAQ classifier. Return only JSON: {intent:string,confidence:number,reply:string}. Only answer public product facts, features, or business-hours questions. Never provide account, payment, security, legal, medical, or transactional help. If uncertain, intent must be unknown and reply empty."}, {"role": "user", "content": text}],
        )
        data = json.loads(result.output_text)
        confidence = float(data.get("confidence", 0))
        intent = str(data.get("intent", "unknown"))
        reply = str(data.get("reply", "")).strip()
    except Exception:
        return RoutingDecision("escalate", "classification_failed")
    if intent not in SAFE_INTENTS or confidence < CONFIDENCE_THRESHOLD or not reply:
        return RoutingDecision("escalate", "low_confidence_or_unsupported_intent")
    return RoutingDecision("reply", "safe_faq", reply[:800])
