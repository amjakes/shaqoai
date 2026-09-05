import hashlib
import hmac

from src.support_workflow import consent_command, route_message
from src.whatsapp import inbound_messages, verify_challenge, verify_signature


def test_webhook_signature_and_challenge_require_matching_secrets():
    body = b'{"object":"whatsapp_business_account"}'
    signature = "sha256=" + hmac.new(b"secret", body, hashlib.sha256).hexdigest()
    assert verify_signature(body, signature, "secret")
    assert not verify_signature(body, signature, "wrong")
    assert verify_challenge("subscribe", "token", "challenge", "token") == "challenge"
    assert verify_challenge("subscribe", "wrong", "challenge", "token") is None


def test_parser_accepts_text_messages_only():
    payload = {"entry": [{"changes": [{"value": {"metadata": {"phone_number_id": "phone-1"}, "messages": [{"id": "wamid-1", "from": "254700000000", "type": "text", "text": {"body": "Hello"}}, {"id": "wamid-2", "from": "254700000000", "type": "image"}]}}]}]}
    messages = list(inbound_messages(payload))
    assert len(messages) == 1
    assert messages[0].event_id == "wamid-1"


def test_consent_and_sensitive_requests_never_reach_autonomous_reply():
    assert consent_command("STOP") == "opt_out"
    assert consent_command("START") == "opt_in"
    assert route_message("Please refund my M-Pesa payment").outcome == "escalate"
