---
name: feature
description:
  Start feature development workflow. Creates temp/<feature-name>/feature.md with proposal. Use
  kebab-case for feature names.
metadata:
  claude-disable-model-invocation: 'true'
---

Start feature development workflow.

## Current State

- Branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`
- Uncommitted changes: !`git status --short`
- Existing features: !`ls -1 temp/ 2>/dev/null || echo "(none)"`

## Workflow

1. **Parse feature name**: Convert `$ARGUMENTS` to kebab-case (e.g., "Lazy Loading" →
   "lazy-loading")
2. **Check existing**: Read `temp/<feature-name>/feature.md` if directory exists
3. **Create directory**: `temp/<feature-name>/` if it doesn't exist
4. **Create/Update proposal** at `temp/<feature-name>/feature.md`:

```markdown
# Feature: [Name]

## Problem

[What problem does this solve?]

## Solution

[How will we solve it?]

## Files to Modify

- [ ] `path/to/file` - description
- [ ] `path/to/test` - description

## Checklist

- [ ] Implementation
- [ ] Tests
- [ ] Update documentation
- [ ] Update changelog
```

5. **Ask clarifying questions** about requirements if needed

## Important

- `temp/` directory should be in `.gitignore` — working documents, not committed
- Each feature has its own directory for all related files (notes, research, etc.)
- Follow the checklist during implementation
- Update all docs after implementation is complete
- Directories are kept after feature completion (manual cleanup when needed)

Feature request: $ARGUMENTS
