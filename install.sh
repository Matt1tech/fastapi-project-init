#!/usr/bin/env bash
# Install the fastapi-project-generator skill for AI coding agents.
#
# Usage:
#   ./install.sh [--agent agents|claude|codex|cursor|copilot|gemini|windsurf|all] [--project]
#
#   --agent    target agent (default: agents, the generic AGENTS.md standard)
#   --project  install into the current directory instead of your home directory
#
# User-wide install is supported for: claude, codex.
# cursor, copilot, gemini and windsurf are project-level only.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL="$ROOT/skills/fastapi-project-generator"
NAME="fastapi-project-generator"
AGENT="agents"
PROJECT=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="${2:?--agent needs a value}"; shift 2 ;;
    --project) PROJECT=1; shift ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

copy_skill() { # $1 = skills root dir
  mkdir -p "$1"
  rm -rf "${1:?}/$NAME"
  cp -r "$SKILL" "$1/"
  echo "Installed skill -> $1/$NAME"
}

# Append the pointer section to an instructions file unless already present.
add_pointer() { # $1 = file
  mkdir -p "$(dirname "$1")"
  if [[ -f "$1" ]] && grep -q "$NAME" "$1"; then
    echo "Already configured: $1"
  else
    { [[ -s "$1" ]] && echo; cat "$ROOT/adapters/instructions.md"; } >> "$1"
    echo "Updated $1"
  fi
}

need_project() {
  if [[ $PROJECT -eq 0 ]]; then
    echo "'$1' is project-level only; installing into $(pwd)"
  fi
}

install_one() {
  case "$1" in
    claude)
      if [[ $PROJECT -eq 1 ]]; then copy_skill "$(pwd)/.claude/skills"; else copy_skill "$HOME/.claude/skills"; fi ;;
    codex)
      if [[ $PROJECT -eq 1 ]]; then
        copy_skill "$(pwd)/.agents/skills"
      else
        copy_skill "$HOME/.codex/skills"
      fi ;;
    agents)
      copy_skill "$(pwd)/.agents/skills"; add_pointer "$(pwd)/AGENTS.md" ;;
    cursor)
      need_project cursor
      copy_skill "$(pwd)/.agents/skills"
      mkdir -p "$(pwd)/.cursor/rules"
      cp "$ROOT/adapters/cursor/$NAME.mdc" "$(pwd)/.cursor/rules/$NAME.mdc"
      echo "Installed Cursor rule -> .cursor/rules/$NAME.mdc" ;;
    copilot)
      need_project copilot
      copy_skill "$(pwd)/.agents/skills"; add_pointer "$(pwd)/.github/copilot-instructions.md" ;;
    gemini)
      need_project gemini
      copy_skill "$(pwd)/.agents/skills"; add_pointer "$(pwd)/GEMINI.md" ;;
    windsurf)
      need_project windsurf
      copy_skill "$(pwd)/.agents/skills"; add_pointer "$(pwd)/.windsurf/rules/$NAME.md" ;;
    *) echo "Unknown agent: $1" >&2; exit 1 ;;
  esac
}

if [[ "$AGENT" == "all" ]]; then
  PROJECT=1
  for a in agents claude codex cursor copilot gemini windsurf; do install_one "$a"; done
else
  install_one "$AGENT"
fi

echo "Done. Restart your agent, then ask it: \"create a new FastAPI project\"."
