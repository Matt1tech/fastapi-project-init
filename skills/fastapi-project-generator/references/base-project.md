# Base project

## Default stack

Python 3.12+, uv, FastAPI, Uvicorn, Pydantic v2 + Pydantic Settings, HTTPX,
Pytest + pytest-asyncio, Ruff. Add SQLAlchemy 2.x, Alembic and psycopg only when PostgreSQL is selected.

## Layout (modular layered default)

```
project/
├── backend/
│   ├── app/
│   │   ├── api/routes/
│   │   ├── core/
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── repositories/
│   │   ├── services/
│   │   ├── integrations/
│   │   ├── middleware/
│   │   └── main.py
│   ├── tests/
│   ├── pyproject.toml
│   └── uv.lock
├── docker-compose.yml      # only if Docker selected
├── .env.example
├── .gitignore
└── README.md
```

Omit folders that would be empty for the selected services (e.g. no `repositories/`
or `models/` without a database). Do not create a duplicate `src/`.

## uv rules

```bash
cd backend
uv init --python 3.12 --no-readme --bare   # then edit pyproject.toml
uv add <package>
uv add --dev <package>
uv sync
uv run <command>
```

For a non-packaged app add to `pyproject.toml`:

```toml
[tool.uv]
package = false
```

Do not configure a build backend or `[project.scripts]` unless the user wants an installable package.
Do not move `pyproject.toml` away from `uv.lock`. Do not create extra virtualenvs.

## Tooling config

```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"
testpaths = ["tests"]

[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "ASYNC"]
```

## Required starter files

- `app/main.py` - app factory / `FastAPI(...)`, include routers, docs at `/docs`
- `app/core/config.py` - `pydantic_settings.BaseSettings`, cached `get_settings()` via `lru_cache`
- `app/api/routes/health.py` - `GET /health` -> `{"status": "ok"}`
- `tests/test_health.py` - uses `httpx.AsyncClient` with `ASGITransport`, asserts 200 and body
- `.env.example` - every setting with placeholder values, no real secrets
- `.gitignore` - `.env`, `.venv/`, `__pycache__/`, `.pytest_cache/`, `.ruff_cache/`
- `README.md` - setup, run, test, lint, Docker commands

## Code standards

- Type annotations everywhere; async endpoints for async I/O.
- Dependency injection via `Depends`.
- Thin routes; business logic in services; DB access in repositories.
- Validate input/output with Pydantic schemas.
- Parameterized SQL / ORM only.
- Meaningful tests; avoid unnecessary abstractions.
