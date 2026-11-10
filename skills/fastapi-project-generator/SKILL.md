---
name: fastapi-project-generator
description: Interactively scaffold a production-minded FastAPI backend using Python 3.12, uv, and a chosen architecture (modular layered, clean, hexagonal, minimal, microservices), with optional PostgreSQL, Redis, Qdrant, JWT auth, Docker Compose, and AI modules (LangChain, LangGraph, RAG, MCP). Use when the user wants to start a new FastAPI project, scaffold a backend, or says "/fastapi-project-generator".
---

# FastAPI Project Generator

Generate a clean, verified FastAPI project. Interview the user briefly, recommend
sensible defaults, scaffold, then verify with real commands.

## Step 1 - Interview

Use your agent's structured question tool if it has one (e.g. `AskUserQuestion` in
Claude Code). If not, ask the same questions in chat as a short numbered list with
lettered options and the recommended option marked, then wait for the reply.

Ask in at most two rounds. Skip any question the user already
answered in their message. Always mark the recommended option first with
"(Recommended)". Never ask about things that have a safe default.

**Round 1 - essentials** (one batch, up to 4 questions):

1. **Project name** - free text (use "Other"). Offer a short suggestion based on the
   directory name. Normalize to kebab-case for the folder and snake_case for Python names.
2. **Target folder** - options: current directory `./<name>` (Recommended), a custom
   path (Other).
3. **Architecture** - Modular layered (Recommended), Minimal, Clean Architecture,
   Hexagonal. Microservices only appears via "Other"; if chosen, ask why, and warn
   against it for small apps (see `references/architectures.md`).
4. **Services** (multiSelect) - PostgreSQL + SQLAlchemy + Alembic, JWT auth,
   Redis, Docker Compose. Recommend PostgreSQL and Docker Compose.

**Round 2 - optional extras** (only ask if relevant; one batch):

1. **Vector DB** (multiSelect, only if the user wants AI/RAG or Qdrant): Qdrant,
   PostgreSQL pgvector, None.
2. **AI modules** (multiSelect): None (Recommended), LangChain, LangGraph, RAG, MCP.
3. **LLM provider** (only if an AI module is selected): OpenAI, Anthropic,
   Google Gemini, Ollama (local).
4. **Persist conversation state?** (only if LangGraph selected): Yes via Postgres
   checkpointer / No (in-memory).

Then print a 6-line summary of the choices and proceed - do not ask for another
confirmation unless the target folder is non-empty.

## Step 2 - Safety checks

1. Resolve the target path. If it exists and is non-empty, STOP and ask whether to
   use a different folder or merge. Never overwrite existing files without explicit approval.
2. Confirm `uv` is installed (`uv --version`). If not, tell the user how to install it
   (`curl -LsSf https://astral.sh/uv/install.sh | sh`) and stop.
3. Confirm Docker is available only if Docker Compose was selected, and only for the
   verification step.

## Step 3 - Scaffold

Read the matching reference files before generating code:

- Always: `references/base-project.md` (layout, starter files, uv rules, code standards)
- Architecture chosen: `references/architectures.md`
- Services chosen: `references/services.md` (dependencies, Docker standards)
- Any AI module: `references/ai-rag.md`

Rules that always apply:

- Python 3.12, uv only (never pip). `backend/pyproject.toml` and `backend/uv.lock` stay together.
- `[tool.uv] package = false` unless the user explicitly wants an installable package.
- No `src/` directory. No empty abstraction layers.
- Add dependencies only for selected services, via `uv add` / `uv add --dev`.
- Required files: `app/main.py`, `app/core/config.py`, `app/api/routes/health.py`,
  `tests/test_health.py`, `.env.example`, `.gitignore`, `README.md`.
- `/health` returns HTTP 200 `{"status": "ok"}`; Swagger at `/docs`.
- Never put secrets in source; never commit `.env`.
- AI folders, endpoints and dependencies exist only if requested.

## Step 4 - Verify (never claim success without running)

From `backend/`:

```bash
uv sync
uv run ruff check .
uv run ruff format --check .
uv run pytest -v
```

If Docker Compose was selected: `docker compose config` (from the project root).
Run `docker compose up -d` only if the user asks, or ask once. Fix failures and rerun.
If something cannot be verified, say so.

## Step 5 - Delivery report

Report concisely:

1. Project location
2. Architecture selected
3. Services included
4. Dependencies installed
5. Files created (tree)
6. Command to run the API: `cd backend && uv run uvicorn app.main:app --reload`
7. Command to run tests: `cd backend && uv run pytest -v`
8. Actual test and lint results
9. Known limitations

Finish by offering one next step (e.g. "add a first domain module", "git init and push").
