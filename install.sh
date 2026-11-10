#!/usr/bin/env bash
# Install the fastapi-project-generator skill for Claude Code.
# Usage: ./install.sh            (user-wide: ~/.claude/skills)
#        ./install.sh --project  (current project: ./.claude/skills)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills/fastapi-project-generator"
DEST_ROOT="${HOME}/.claude/skills"
[[ "${1:-}" == "--project" ]] && DEST_ROOT="$(pwd)/.claude/skills"

mkdir -p "$DEST_ROOT"
rm -rf "${DEST_ROOT}/fastapi-project-generator"
cp -r "$SRC" "$DEST_ROOT/"
echo "Installed to ${DEST_ROOT}/fastapi-project-generator"
echo "Restart Claude Code, then run: /fastapi-project-generator"
