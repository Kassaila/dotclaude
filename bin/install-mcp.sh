#!/bin/bash

# Merge global MCP servers into ~/.claude/settings.json
# Preserves existing settings — only adds/updates mcpServers entries

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MCP_FILE="$REPO_DIR/mcp/global-servers.json"
SETTINGS_FILE="$HOME/.claude/settings.json"

if [ ! -f "$MCP_FILE" ]; then
  echo "ERROR: mcp/global-servers.json not found"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "ERROR: jq is required (apt install jq)"
  exit 1
fi

if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# Merge MCP servers into existing settings.json
jq --argjson mcp "$(cat "$MCP_FILE")" \
  '.mcpServers = (.mcpServers // {} | . * $mcp)' \
  "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" \
  && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "MCP servers merged into $SETTINGS_FILE:"
jq -r '.mcpServers | keys[]' "$SETTINGS_FILE" | sed 's/^/  - /'
