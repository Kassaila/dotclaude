---
name: update-docs
description:
  Update documentation after code changes. Delegates to docs-updater agent. Use when user says
  "update docs", "sync docs", or asks to update documentation after making changes. TRIGGER when
  user explicitly asks to update docs, says "update docs", or uses /update-docs. DO NOT TRIGGER when
  user is writing new documentation from scratch, or editing docs manually.
---

Update documentation by delegating to the `docs-updater` agent.

## Usage

```
/update-docs              # update docs based on recent changes (default)
/update-docs <file>       # update docs related to a specific changed file
/update-docs all          # scan all docs for staleness
```

## Process

1. **Parse scope** from `$ARGUMENTS` into a description for the agent:
   - No argument or `recent` → "update docs based on recent changes"
   - File path → "update docs related to changes in <path>"
   - `all` → "scan all documentation for staleness"

2. **Delegate to agent**: invoke the `docs-updater` agent with the scope description. The agent
   handles everything — detects changes, finds docs, checks relevance, updates. Runs on sonnet model
   for efficiency.

3. **Present results**: show the agent's findings to the user as-is.

## Rules

- The skill is a thin router — all docs logic lives in the agent
