#!/bin/bash

# Install external skills from external-skills.json via npx skills

set -euo pipefail

for cmd in jq npx; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd is required but not installed"
    exit 1
  fi
done

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$REPO_DIR/external-skills.json"

if [ ! -f "$CONFIG" ]; then
  echo "ERROR: $CONFIG not found"
  exit 1
fi

skills=$(jq -r '.skills[] | .source + " " + .name' "$CONFIG")

if [ -z "$skills" ]; then
  echo "No external skills defined in external-skills.json"
  exit 0
fi

count=$(echo "$skills" | wc -l)
echo "Installing $count external skill(s)..."
echo ""

echo "$skills" | while read -r src name; do
  echo "  Installing: $name (from $src)"
  npx skills add "$src" -s "$name" -g --agent claude-code -y
done

echo ""
echo "Done! External skills installed to ~/.claude/skills/"
