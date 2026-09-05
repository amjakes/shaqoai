# ShaqoAI backend — Stage 1

## Local secure stack

```powershell
cd apps/backend
Copy-Item .env.example .env
docker compose up -d postgres redis
python -m pip install -r requirements.txt
python -m alembic upgrade head
python -m uvicorn src.main:app --reload --port 8000
```

Run the worker in another terminal:

```powershell
cd apps/backend
python -m celery -A src.worker.celery_app worker --loglevel=INFO
```

For production, set `ENVIRONMENT=production`, use a managed PostgreSQL instance with `pgvector` enabled, a managed Redis instance, a unique 32+ character `JWT_SECRET`, HTTPS-only OAuth callback URLs, and allowed production CORS origins. Never use the sample `.env` credentials in a deployed environment.

## Stage 1 checks

```powershell
python -m pytest -q
python -m compileall -q src
python -m alembic heads
python -m pip check
```
