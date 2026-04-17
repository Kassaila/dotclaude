#!/bin/bash

# Symlink skills, agents, and config from dotclaude to ~/.claude/
# Does not overwrite skills installed by other tools (e.g. npx skills)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Remove old directory-level symlinks if they exist
for dir in skills agents; do
  if [ -L "$CLAUDE_DIR/$dir" ]; then
    echo "Removing old directory symlink: $CLAUDE_DIR/$dir"
    rm "$CLAUDE_DIR/$dir"
  fi
done

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents"

# Remove broken symlinks that point into this repo (stale from renames/removals)
for dir in "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents"; do
  [ -d "$dir" ] || continue
  for link in "$dir"/*; do
    [ -L "$link" ] || continue
    target="$(readlink "$link")"
    case "$target" in
      "$REPO_DIR"/*)
        if [ ! -e "$link" ]; then
          echo "  CLEAN: $(basename "$dir")/$(basename "$link") (broken)"
          rm "$link"
        fi
        ;;
    esac
  done
done

# Symlink each skill individually
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_DIR/skills/$skill_name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "SKIP: skills/$skill_name (exists and is not a symlink)"
  else
    # -n prevents creating link inside existing directory target
    ln -sfn "$skill_dir" "$target"
    echo "  OK: skills/$skill_name"
  fi
done

# Symlink each agent individually
for agent_file in "$REPO_DIR"/agents/*.md; do
  agent_name="$(basename "$agent_file")"
  target="$CLAUDE_DIR/agents/$agent_name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "SKIP: agents/$agent_name (exists and is not a symlink)"
  else
    ln -sf "$agent_file" "$target"
    echo "  OK: agents/$agent_name"
  fi
done

# Symlink global-claude.md as CLAUDE.md
if [ -f "$REPO_DIR/global-claude.md" ]; then
  ln -sf "$REPO_DIR/global-claude.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  OK: CLAUDE.md (from global-claude.md)"
fi

echo ""
echo "Done! Global config installed to ~/.claude/"
