import hashlib
import uuid
from datetime import UTC, datetime, timedelta

import jwt
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from passlib.context import CryptContext
from sqlalchemy import select
from sqlalchemy.orm import Session

from .config import get_settings
from .database import get_db
from .models import User, WorkspaceMembership, WorkspaceRole

password_context = CryptContext(schemes=["argon2"], deprecated="auto")
bearer = HTTPBearer(auto_error=False)
settings = get_settings()

ROLE_RANK = {WorkspaceRole.viewer: 0, WorkspaceRole.member: 1, WorkspaceRole.manager: 2, WorkspaceRole.admin: 3, WorkspaceRole.owner: 4}


def hash_password(password: str) -> str:
    return password_context.hash(password)


def verify_password(password: str, hashed_password: str) -> bool:
    return password_context.verify(password, hashed_password)


def create_access_token(user_id: uuid.UUID) -> str:
    now = datetime.now(UTC)
    return jwt.encode({"sub": str(user_id), "iss": settings.jwt_issuer, "aud": settings.jwt_audience, "iat": now, "exp": now + timedelta(minutes=settings.jwt_access_minutes)}, settings.jwt_secret, algorithm="HS256")


def current_user(credentials: HTTPAuthorizationCredentials | None = Depends(bearer), db: Session = Depends(get_db)) -> User:
    if credentials is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Authentication required")
    try:
        claims = jwt.decode(credentials.credentials, settings.jwt_secret, algorithms=["HS256"], audience=settings.jwt_audience, issuer=settings.jwt_issuer)
        user_id = uuid.UUID(claims["sub"])
    except (jwt.PyJWTError, KeyError, ValueError) as error:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired access token") from error
    user = db.get(User, user_id)
    if user is None or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid account")
    return user


def workspace_member(request: Request, user: User = Depends(current_user), db: Session = Depends(get_db)) -> WorkspaceMembership:
    raw_workspace_id = request.headers.get("X-Workspace-ID")
    if not raw_workspace_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="X-Workspace-ID header is required")
    try:
        workspace_id = uuid.UUID(raw_workspace_id)
    except ValueError as error:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="X-Workspace-ID must be a UUID") from error
    membership = db.scalar(select(WorkspaceMembership).where(WorkspaceMembership.workspace_id == workspace_id, WorkspaceMembership.user_id == user.id))
    if membership is None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Workspace access denied")
    return membership


def require_role(minimum: WorkspaceRole):
    def dependency(membership: WorkspaceMembership = Depends(workspace_member)) -> WorkspaceMembership:
        if ROLE_RANK[membership.role] < ROLE_RANK[minimum]:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient workspace role")
        return membership
    return dependency


def token_fingerprint(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()[:12]
