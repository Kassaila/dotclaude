#!/bin/bash

# Install external skills from external-skills.json via npx skills

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$REPO_DIR/external-skills.json"

if [ ! -f "$CONFIG" ]; then
  echo "ERROR: $CONFIG not found"
  exit 1
fi

count=$(jq '.skills | length' "$CONFIG")

if [ "$count" -eq 0 ]; then
  echo "No external skills defined in external-skills.json"
  exit 0
fi

echo "Installing $count external skill(s)..."
echo ""

for i in $(seq 0 $((count - 1))); do
  source=$(jq -r ".skills[$i].source" "$CONFIG")
  name=$(jq -r ".skills[$i].name" "$CONFIG")
  echo "  Installing: $name (from $source)"
  npx skills add "$source" -s "$name" -g --agent claude-code -y
done

echo ""
echo "Done! External skills installed to ~/.claude/skills/"
