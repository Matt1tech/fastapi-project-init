# AI agent and RAG modules

AI capabilities are optional. Never add AI dependencies, folders or endpoints unless selected.
Check package compatibility before adding dependencies; pin via `uv.lock`.
Install only packages for the selected provider/module.

## LangChain
Create `ai/llm/`, `ai/prompts/`, `ai/integrations/`. Use for model integrations,
prompt templates, document loaders and tool adapters.

## LangGraph
Create `ai/agents/graph.py`, `state.py`, `nodes/`, `tools/`, `routing/`.
Explicit state schema, nodes, edges and conditional routing.
Keep business authorization outside the LLM.

## RAG
Create `ai/rag/{ingestion.py, loaders/, chunking.py, embeddings.py, retrieval.py, vector_store.py, evaluation.py}`
plus `documents/` and `evaluation/datasets/`.
Separate ingestion from query-time retrieval. Support metadata filtering, source
references, configurable chunking, retrieval limits and relevance thresholds.
Do not claim RAG eliminates hallucinations.

## Vector database
Selectable: Qdrant or PostgreSQL + pgvector. Define a `VectorStore` interface
(Protocol) so provider-specific code does not leak into services.

## LLM provider
Configurable: OpenAI (`langchain-openai`), Anthropic (`langchain-anthropic`),
Google Gemini (`langchain-google-genai`), Ollama (`langchain-ollama`).
Keys in environment variables only; list them in `.env.example` with empty values.

## Conversation memory
Keep conversation state separate from long-term knowledge retrieval.
Persist only when requested; use a configurable LangGraph checkpointer
(in-memory by default, Postgres when persistence is chosen).

## MCP
Create MCP client and tool-adapter modules. Validate tool inputs and permissions
independently. Never let an LLM bypass backend authorization.

## AI evaluation tests
Separate tests for: retrieval relevance, context precision/recall, grounded answer
quality, tool selection/execution, agent routing, failure and timeout handling.
Use deterministic mocks; do not require paid LLM calls in unit tests.

## Endpoints (only for selected features)
- `POST /api/v1/ai/chat`
- `POST /api/v1/ai/agents/run`
- `POST /api/v1/ai/rag/ingest`
- `POST /api/v1/ai/rag/search`

Routes stay thin and call application services.
