import re
import uuid

from authlib.integrations.starlette_client import OAuth
from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.responses import RedirectResponse
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from .config import get_settings
from .database import get_db
from .models import AuditLog, User, Workspace, WorkspaceMembership, WorkspaceRole
from .schemas import LoginRequest, MemberCreateRequest, MemberResponse, RegisterRequest, TokenResponse, UserResponse, WorkspaceCreateRequest, WorkspaceResponse
from .security import create_access_token, current_user, hash_password, require_role, verify_password, workspace_member

router = APIRouter(prefix="/api/v1")
settings = get_settings()
oauth = OAuth()
if settings.google_client_id and settings.google_client_secret:
    oauth.register(
        name="google",
        client_id=settings.google_client_id,
        client_secret=settings.google_client_secret,
        server_metadata_url=settings.google_server_metadata_url,
        client_kwargs={"scope": "openid email profile"},
    )


def workspace_slug(name: str) -> str:
    base = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")[:120] or "workspace"
    return f"{base}-{uuid.uuid4().hex[:8]}"


def audit(db: Session, workspace_id: uuid.UUID, event_type: str, actor_id: uuid.UUID | None, metadata: dict | None = None) -> None:
    db.add(AuditLog(workspace_id=workspace_id, actor_id=actor_id, event_type=event_type, metadata_json=metadata or {}))


@router.post("/auth/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    if db.scalar(select(User).where(User.email == payload.email.lower())):
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email is already registered")
    user = User(email=payload.email.lower(), display_name=payload.display_name, password_hash=hash_password(payload.password))
    workspace = Workspace(name=payload.workspace_name, slug=workspace_slug(payload.workspace_name))
    db.add_all([user, workspace])
    db.flush()
    db.add(WorkspaceMembership(workspace_id=workspace.id, user_id=user.id, role=WorkspaceRole.owner))
    audit(db, workspace.id, "workspace.created", user.id)
    db.commit()
    return TokenResponse(access_token=create_access_token(user.id), expires_in=settings.jwt_access_minutes * 60)


@router.post("/auth/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == payload.email.lower()))
    if user is None or user.password_hash is None or not user.is_active or not verify_password(payload.password, user.password_hash):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password")
    return TokenResponse(access_token=create_access_token(user.id), expires_in=settings.jwt_access_minutes * 60)


@router.get("/auth/me", response_model=UserResponse)
def me(user: User = Depends(current_user)):
    return user


@router.get("/workspaces", response_model=list[WorkspaceResponse])
def list_workspaces(user: User = Depends(current_user), db: Session = Depends(get_db)):
    memberships = db.scalars(select(WorkspaceMembership).where(WorkspaceMembership.user_id == user.id)).all()
    return [WorkspaceResponse(id=membership.workspace.id, name=membership.workspace.name, slug=membership.workspace.slug, role=membership.role) for membership in memberships]


@router.post("/workspaces", response_model=WorkspaceResponse, status_code=status.HTTP_201_CREATED)
def create_workspace(payload: WorkspaceCreateRequest, user: User = Depends(current_user), db: Session = Depends(get_db)):
    workspace = Workspace(name=payload.name, slug=workspace_slug(payload.name))
    db.add(workspace)
    db.flush()
    db.add(WorkspaceMembership(workspace_id=workspace.id, user_id=user.id, role=WorkspaceRole.owner))
    audit(db, workspace.id, "workspace.created", user.id)
    db.commit()
    return WorkspaceResponse(id=workspace.id, name=workspace.name, slug=workspace.slug, role=WorkspaceRole.owner)


@router.get("/workspace/members", response_model=list[MemberResponse])
def list_members(membership: WorkspaceMembership = Depends(workspace_member), db: Session = Depends(get_db)):
    memberships = db.scalars(select(WorkspaceMembership).where(WorkspaceMembership.workspace_id == membership.workspace_id)).all()
    return [MemberResponse(user_id=item.user.id, email=item.user.email, role=item.role) for item in memberships]


@router.post("/workspace/members", response_model=MemberResponse, status_code=status.HTTP_201_CREATED)
def add_member(payload: MemberCreateRequest, request: Request, membership: WorkspaceMembership = Depends(require_role(WorkspaceRole.admin)), db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == payload.email.lower()))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User must register before being added to a workspace")
    existing = db.scalar(select(WorkspaceMembership).where(WorkspaceMembership.workspace_id == membership.workspace_id, WorkspaceMembership.user_id == user.id))
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User is already a workspace member")
    new_membership = WorkspaceMembership(workspace_id=membership.workspace_id, user_id=user.id, role=payload.role)
    db.add(new_membership)
    audit(db, membership.workspace_id, "workspace.member_added", membership.user_id, {"member_id": str(user.id), "role": payload.role.value, "request_id": request.state.request_id})
    db.commit()
    return MemberResponse(user_id=user.id, email=user.email, role=payload.role)


@router.get("/auth/oauth/{provider}")
async def oauth_start(provider: str, request: Request):
    if provider != "google" or not settings.google_client_id or not settings.google_client_secret:
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail="OAuth provider is not configured")
    return await oauth.google.authorize_redirect(request, str(request.url_for("oauth_callback", provider="google")))


@router.get("/auth/oauth/{provider}/callback", response_model=TokenResponse, name="oauth_callback")
async def oauth_callback(provider: str, request: Request, db: Session = Depends(get_db)):
    if provider != "google" or not settings.google_client_id or not settings.google_client_secret:
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail="OAuth provider is not configured")
    token = await oauth.google.authorize_access_token(request)
    profile = token.get("userinfo") or await oauth.google.userinfo(token=token)
    email = profile.get("email")
    if not email or not profile.get("email_verified", False):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Verified Google email is required")
    user = db.scalar(select(User).where(User.email == email.lower()))
    if user is None:
        user = User(email=email.lower(), display_name=profile.get("name") or email.split("@")[0], password_hash=None)
        workspace = Workspace(name=f"{user.display_name}'s Workspace", slug=workspace_slug(user.display_name))
        db.add_all([user, workspace])
        db.flush()
        db.add(WorkspaceMembership(workspace_id=workspace.id, user_id=user.id, role=WorkspaceRole.owner))
        audit(db, workspace.id, "workspace.created_via_oauth", user.id, {"provider": "google"})
        db.commit()
    return TokenResponse(access_token=create_access_token(user.id), expires_in=settings.jwt_access_minutes * 60)
