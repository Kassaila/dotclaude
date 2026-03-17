#!/bin/bash

# Remove only dotclaude symlinks from ~/.claude/
# Does not touch skills installed by other tools (e.g. npx skills)

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Remove skill symlinks that point to dotclaude
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "  Removed: skills/$skill_name"
  fi
done

# Remove agent symlinks that point to dotclaude
for agent_file in "$REPO_DIR"/agents/*.md; do
  agent_name="$(basename "$agent_file")"
  target="$CLAUDE_DIR/agents/$agent_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "  Removed: agents/$agent_name"
  fi
done

# Remove CLAUDE.md symlink
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  rm "$CLAUDE_DIR/CLAUDE.md"
  echo "  Removed: CLAUDE.md"
fi

echo ""
echo "Done! Global config removed from ~/.claude/"
