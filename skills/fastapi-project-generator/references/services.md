# Services and dependencies

Add only what the user selected.

| Selection | `uv add` |
|---|---|
| Always | `fastapi "uvicorn[standard]" pydantic-settings httpx` |
| Always (dev) | `uv add --dev pytest pytest-asyncio ruff` |
| PostgreSQL | `sqlalchemy alembic "psycopg[binary]"` |
| JWT auth | `pyjwt "pwdlib[argon2]"` |
| Redis | `redis` |
| Qdrant | `qdrant-client` |
| pgvector | `pgvector` (requires PostgreSQL) |

Notes:
- `httpx` is a runtime dependency (integrations) and used by tests.
- Use async SQLAlchemy (`create_async_engine`, `postgresql+psycopg://`) when endpoints are async.
- Initialize Alembic inside `backend/` (`uv run alembic init -t async migrations`).
- JWT: secrets from env, short expiry, hash passwords with pwdlib Argon2; never log tokens.

## Docker standards

- Use Docker Compose (`docker-compose.yml` at project root).
- Health checks on infrastructure services (`pg_isready`, `redis-cli ping`, Qdrant `/readyz`).
- Named volumes for database data.
- Credentials from environment variables (`${POSTGRES_PASSWORD}`), never hardcoded production secrets.
- Provide a `backend/Dockerfile` using the official uv image and `uv sync --frozen --no-dev`.
- Document start/stop in README: `docker compose up -d`, `docker compose down`.
