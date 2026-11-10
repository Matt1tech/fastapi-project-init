# fastapi-project-init

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-skill-blueviolet)](https://claude.com/claude-code)
[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://www.python.org/)
[![uv](https://img.shields.io/badge/deps-uv-orange)](https://docs.astral.sh/uv/)

A reusable [Claude Code](https://claude.com/claude-code) skill that interviews you and
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

- [Claude Code](https://claude.com/claude-code)
- [uv](https://docs.astral.sh/uv/getting-started/installation/)
- Docker (only if you choose Docker Compose)

## Installation

```bash
git clone https://github.com/Matt1tech/fastapi-project-init.git
cd fastapi-project-init
./install.sh              # user-wide, installs to ~/.claude/skills
# ./install.sh --project  # or only for the current project
```

Restart Claude Code after installing.

## Usage

```
/fastapi-project-generator
```

Or ask in plain language: *"Create a new FastAPI project called shop-api with Postgres and Docker."*
Claude asks only what you haven't already told it.

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
install.sh
```

## Contributing

Issues and pull requests are welcome. Keep `SKILL.md` short and put detail in `references/`.

## Author

Created by **Matt1tech** ([@Matt1tech](https://github.com/Matt1tech)).

## License

Released under the [MIT License](LICENSE).
