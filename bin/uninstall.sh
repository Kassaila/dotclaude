#!/bin/bash

# Remove only dotclaude symlinks from ~/.claude/
# Does not touch skills installed by other tools (e.g. npx skills)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Remove skill symlinks that point to dotclaude
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    case "$link_target" in
      "$REPO_DIR"/*) rm "$target"; echo "  Removed: skills/$skill_name" ;;
      *) echo "  SKIP: skills/$skill_name (not a dotclaude symlink)" ;;
    esac
  fi
done

# Remove agent symlinks that point to dotclaude
for agent_file in "$REPO_DIR"/agents/*.md; do
  agent_name="$(basename "$agent_file")"
  target="$CLAUDE_DIR/agents/$agent_name"
  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    case "$link_target" in
      "$REPO_DIR"/*) rm "$target"; echo "  Removed: agents/$agent_name" ;;
      *) echo "  SKIP: agents/$agent_name (not a dotclaude symlink)" ;;
    esac
  fi
done

# Remove CLAUDE.md symlink (points to global-claude.md)
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  link_target="$(readlink "$CLAUDE_DIR/CLAUDE.md")"
  case "$link_target" in
    "$REPO_DIR"/*) rm "$CLAUDE_DIR/CLAUDE.md"; echo "  Removed: CLAUDE.md" ;;
    *) echo "  SKIP: CLAUDE.md (not a dotclaude symlink)" ;;
  esac
fi

echo ""
echo "Done! Global config removed from ~/.claude/"
