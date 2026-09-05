# ShaqoAI backend — Stages 1–2

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

## Stage 2 WhatsApp support setup

Set `WHATSAPP_VERIFY_TOKEN`, `WHATSAPP_APP_SECRET`, and `WHATSAPP_ACCESS_TOKEN` in the deployment secret store, then configure Meta to call `GET` and `POST /api/v1/integrations/whatsapp/webhook`. Connect each Meta phone number to exactly one workspace through `POST /api/v1/workspace/whatsapp-channels` as an Owner or Admin.

The support workflow only auto-replies to high-confidence public FAQs. Payment, account, security, deletion, legal, medical, complaint, and unclear messages create a workspace-scoped human-review task. `STOP` suppresses automated responses and `START` restores consent. Frontends read `/api/v1/support/conversations` using a bearer token and `X-Workspace-ID`; set `VITE_API_BASE_URL` for web and `SHAQOAI_API_URL`, `SHAQOAI_ACCESS_TOKEN`, and `SHAQOAI_WORKSPACE_ID` Dart defines for Flutter.

## Stage 3 RAG and audit controls

Owners, Admins, and Managers can ingest text through `POST /api/v1/knowledge/ingest`; it is chunked, embedded, and stored under the active workspace only. `POST /api/v1/knowledge/search` returns source citations without cross-workspace results. Support replies require cited workspace evidence. Injected customer messages and injected retrieved chunks fail closed to human review; retrieved content is passed only as explicitly delimited untrusted data.

Every support run writes immutable evidence to `agent_run_audits`: prompt version, citations, tool calls and parameters, approval requirement, outcome, actor, workspace, and timestamp. Administrators can review their own workspace via `GET /api/v1/audit/agent-runs`. PostgreSQL triggers reject updates and deletes on both audit tables.
