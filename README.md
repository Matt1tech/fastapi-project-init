# fastapi-project-init

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Agent skill](https://img.shields.io/badge/agent-skill-blueviolet)](#installation)
[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://www.python.org/)
[![uv](https://img.shields.io/badge/deps-uv-orange)](https://docs.astral.sh/uv/)

A reusable, agent-agnostic skill for [Claude Code](https://claude.com/claude-code), Codex, Cursor, Copilot, Gemini CLI, Windsurf and any `AGENTS.md`-aware agent. It interviews you and
scaffolds a clean, production-minded **FastAPI** backend with **Python 3.12** and **uv**,
then verifies it by running lint and tests.

## Features

- **Interactive:** asks a few focused questions and recommends sensible defaults.
- **Five architectures:** modular layered (default), minimal, clean, hexagonal, microservices.
- **Selectable services:** PostgreSQL (SQLAlchemy 2 + Alembic), JWT auth, Redis, Qdrant, Docker Compose.
- **Optional AI modules:** LangChain, LangGraph, RAG (Qdrant or pgvector), MCP, with OpenAI, Anthropic, Gemini or Ollama.
- **Minimal dependencies:** only packages for the services you pick are installed.
- **Safe:** never overwrites existing files without approval, keeps secrets out of source.
- **Verified:** runs `uv sync`, `ruff check`, `ruff format --check` and `pytest` before reporting success.

## Requirements

- An AI coding agent (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Windsurf, ...)
- [uv](https://docs.astral.sh/uv/getting-started/installation/)
- Docker (only if you choose Docker Compose)

## Installation

```bash
git clone https://github.com/Matt1tech/fastapi-project-init.git
cd fastapi-project-init
./install.sh --agent claude        # user-wide, installs to ~/.claude/skills
```

Pick your agent with `--agent`. Add `--project` to install into the current project instead of your home directory.

| Agent | Command | Where it installs | How you invoke it |
|---|---|---|---|
| Claude Code | `./install.sh --agent claude` | `~/.claude/skills/` | `/fastapi-project-generator` |
| OpenAI Codex | `./install.sh --agent codex` | `~/.codex/skills/` | ask: "create a new FastAPI project" |
| Cursor | `./install.sh --agent cursor` | `.agents/skills/` + `.cursor/rules/` | `@fastapi-project-generator` or ask |
| GitHub Copilot | `./install.sh --agent copilot` | `.agents/skills/` + `.github/copilot-instructions.md` | ask in chat |
| Gemini CLI | `./install.sh --agent gemini` | `.agents/skills/` + `GEMINI.md` | ask |
| Windsurf | `./install.sh --agent windsurf` | `.agents/skills/` + `.windsurf/rules/` | ask |
| Any `AGENTS.md` agent | `./install.sh --agent agents` | `.agents/skills/` + `AGENTS.md` | ask |
| Everything | `./install.sh --agent all` | all of the above (project-level) | |

Cursor, Copilot, Gemini and Windsurf are project-level only; run the installer from the
project where you want the skill. Re-running is safe: existing instruction files are
appended to once, never duplicated or overwritten. Restart your agent after installing.

The skill is plain Markdown. Any other agent can use it by reading
`skills/fastapi-project-generator/SKILL.md`. Agents without a structured question tool
simply ask the same questions in chat.

## Usage

Ask in plain language, for example: *"Create a new FastAPI project called shop-api with Postgres and Docker."*
In Claude Code you can also run `/fastapi-project-generator`. The agent asks only what you haven't already told it.

### Questions asked

| Round | Question | Options |
|---|---|---|
| 1 | Project name | free text |
| 1 | Target folder | `./<name>` or custom |
| 1 | Architecture | Modular layered, Minimal, Clean, Hexagonal, Microservices |
| 1 | Services | PostgreSQL, JWT auth, Redis, Docker Compose |
| 2 | Vector DB | Qdrant, pgvector, none |
| 2 | AI modules | LangChain, LangGraph, RAG, MCP |
| 2 | LLM provider | OpenAI, Anthropic, Gemini, Ollama |
| 2 | Persist conversation state | yes / no |

Round 2 appears only when relevant.

## Generated project (default)

```
project/
├── backend/
│   ├── app/
│   │   ├── api/routes/health.py
│   │   ├── core/config.py
│   │   └── main.py
│   ├── tests/test_health.py
│   ├── pyproject.toml
│   └── uv.lock
├── docker-compose.yml     # if selected
├── .env.example
├── .gitignore
└── README.md
```

Run it:

```bash
cd backend
uv run uvicorn app.main:app --reload   # Swagger UI at http://localhost:8000/docs
uv run pytest -v
```

## Repository structure

```
skills/fastapi-project-generator/
├── SKILL.md              # interview flow and rules
└── references/           # base project, architectures, services, AI/RAG
adapters/                 # per-agent pointer files (Cursor rule, AGENTS.md snippet)
install.sh                # multi-agent installer
```

## Contributing

Issues and pull requests are welcome. Keep `SKILL.md` short and put detail in `references/`.

## Author

Created by **Matt1tech** ([@Matt1tech](https://github.com/Matt1tech)).

## License

Released under the [MIT License](LICENSE).
