from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    environment: str = "development"
    database_url: str = "postgresql+psycopg://shaqoai:shaqoai@localhost:5432/shaqoai"
    redis_url: str = "redis://localhost:6379/0"
    jwt_secret: str = "development-only-secret-change-before-production"
    jwt_issuer: str = "shaqoai-api"
    jwt_audience: str = "shaqoai-clients"
    jwt_access_minutes: int = 30
    cors_origins: list[str] = ["http://localhost:5173"]
    google_client_id: str | None = None
    google_client_secret: str | None = None
    google_server_metadata_url: str = "https://accounts.google.com/.well-known/openid-configuration"

    @field_validator("jwt_secret")
    @classmethod
    def require_secure_production_secret(cls, value: str, info):
        if info.data.get("environment") == "production" and len(value) < 32:
            raise ValueError("JWT_SECRET must be at least 32 characters in production")
        return value


@lru_cache
def get_settings() -> Settings:
    return Settings()
