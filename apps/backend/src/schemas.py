import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field

from .models import WorkspaceRole


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=12, max_length=128)
    display_name: str = Field(min_length=1, max_length=120)
    workspace_name: str = Field(min_length=2, max_length=160)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int


class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: uuid.UUID
    email: EmailStr
    display_name: str


class WorkspaceResponse(BaseModel):
    id: uuid.UUID
    name: str
    slug: str
    role: WorkspaceRole


class WorkspaceCreateRequest(BaseModel):
    name: str = Field(min_length=2, max_length=160)


class MemberCreateRequest(BaseModel):
    email: EmailStr
    role: WorkspaceRole


class MemberResponse(BaseModel):
    user_id: uuid.UUID
    email: EmailStr
    role: WorkspaceRole


class ErrorResponse(BaseModel):
    error: str
    message: str
    request_id: str


class HealthResponse(BaseModel):
    status: str
    timestamp: datetime
