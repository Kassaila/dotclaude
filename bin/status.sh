#!/bin/bash

# Show status of dotclaude symlinks and other installed skills/agents

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Dotclaude skills ==="
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$target" ]; then
    echo "  OK: $skill_name"
  else
    echo "  MISSING: $skill_name"
  fi
done

echo ""
echo "=== Dotclaude agents ==="
for agent_file in "$REPO_DIR"/agents/*.md; do
  agent_name="$(basename "$agent_file" .md)"
  target="$CLAUDE_DIR/agents/$(basename "$agent_file")"
  if [ -L "$target" ]; then
    echo "  OK: $agent_name"
  else
    echo "  MISSING: $agent_name"
  fi
done

echo ""
echo "=== CLAUDE.md (from global-claude.md) ==="
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "  OK: CLAUDE.md -> global-claude.md"
else
  echo "  MISSING: CLAUDE.md"
fi

# MCP servers
echo ""
echo "=== MCP servers ==="
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
MCP_FILE="$REPO_DIR/mcp/global-servers.json"
if [ -f "$SETTINGS_FILE" ] && command -v jq &>/dev/null; then
  if [ -f "$MCP_FILE" ]; then
    for server in $(jq -r 'keys[]' "$MCP_FILE"); do
      if jq -e ".mcpServers.\"$server\"" "$SETTINGS_FILE" &>/dev/null; then
        echo "  OK: $server"
      else
        echo "  MISSING: $server"
      fi
    done
  else
    echo "  (no mcp/global-servers.json)"
  fi
else
  echo "  (no settings.json or jq not installed)"
fi

# Show other (non-dotclaude) skills
echo ""
echo "=== Other skills (npx skills, etc.) ==="
found_other=false
if [ -d "$CLAUDE_DIR/skills" ]; then
  for item in "$CLAUDE_DIR/skills"/*/; do
    [ -d "$item" ] || continue
    item="${item%/}"
    name="$(basename "$item")"
    if [ ! -L "$item" ]; then
      echo "  $name"
      found_other=true
    fi
  done
fi
if [ "$found_other" = false ]; then
  echo "  (none)"
fi
