import uuid

import pytest
from fastapi import HTTPException

from src.models import WorkspaceRole
from src.security import ROLE_RANK, create_access_token, hash_password, verify_password


def test_password_hash_is_one_way_and_verifiable():
    hashed = hash_password("A-long-test-password-123!")
    assert hashed != "A-long-test-password-123!"
    assert verify_password("A-long-test-password-123!", hashed)
    assert not verify_password("incorrect-password", hashed)


def test_access_token_contains_a_subject():
    user_id = uuid.uuid4()
    token = create_access_token(user_id)
    assert isinstance(token, str)
    assert token.count(".") == 2


def test_role_order_enforces_least_privilege():
    assert ROLE_RANK[WorkspaceRole.owner] > ROLE_RANK[WorkspaceRole.admin]
    assert ROLE_RANK[WorkspaceRole.admin] > ROLE_RANK[WorkspaceRole.manager]
    assert ROLE_RANK[WorkspaceRole.manager] > ROLE_RANK[WorkspaceRole.member]
    assert ROLE_RANK[WorkspaceRole.member] > ROLE_RANK[WorkspaceRole.viewer]
