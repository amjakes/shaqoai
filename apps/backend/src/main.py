"""ShaqoAI API: workspace-scoped Stage-1 platform foundation."""
import logging
import time
import uuid
from datetime import UTC, datetime

from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from starlette.middleware.sessions import SessionMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.util import get_remote_address

from .api import router
from .config import get_settings
from .schemas import HealthResponse

settings = get_settings()
limiter = Limiter(key_func=get_remote_address, default_limits=["120/minute"])
logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger("shaqoai.api")

app = FastAPI(title="ShaqoAI Agent API", version="1.0.0", docs_url="/docs", openapi_url="/api/v1/openapi.json")
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
app.add_middleware(SessionMiddleware, secret_key=settings.jwt_secret, https_only=settings.environment == "production", same_site="lax")
app.add_middleware(CORSMiddleware, allow_origins=settings.cors_origins, allow_credentials=True, allow_methods=["GET", "POST", "PATCH", "DELETE"], allow_headers=["Authorization", "Content-Type", "X-Workspace-ID", "Idempotency-Key"])


@app.middleware("http")
async def request_context(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
    request.state.request_id = request_id
    started = time.perf_counter()
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    logger.info('{"request_id":"%s","method":"%s","path":"%s","status":%d,"duration_ms":%.2f}', request_id, request.method, request.url.path, response.status_code, (time.perf_counter() - started) * 1000)
    return response


@app.exception_handler(RequestValidationError)
async def validation_error(request: Request, exc: RequestValidationError):
    return JSONResponse(status_code=422, content={"error": "validation_error", "message": "Invalid request payload", "details": exc.errors(), "request_id": request.state.request_id})


@app.exception_handler(HTTPException)
async def http_error(request: Request, exc: HTTPException):
    message = exc.detail if isinstance(exc.detail, str) else "Request failed"
    return JSONResponse(status_code=exc.status_code, content={"error": "request_error", "message": message, "request_id": request.state.request_id}, headers=exc.headers)


@app.exception_handler(Exception)
async def unhandled_error(request: Request, exc: Exception):
    logger.exception("Unhandled error", exc_info=exc)
    return JSONResponse(status_code=500, content={"error": "internal_error", "message": "An unexpected error occurred", "request_id": getattr(request.state, "request_id", "unknown")})


@app.get("/health", response_model=HealthResponse, tags=["operations"])
@limiter.limit("30/minute")
def health(request: Request):
    return HealthResponse(status="ok", timestamp=datetime.now(UTC))


app.include_router(router)
