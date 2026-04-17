---
name: feature
description:
  Start feature development workflow. Creates .tmp/FEATURE-NAME/feature.md with proposal. Use
  kebab-case for feature names.
allowed-tools: Bash(mkdir*), Bash(git*), Bash(ls*), Read, Write, Edit
---

Start feature development workflow.

## Workflow

1. **Gather context** by running these commands:
   - `git branch --show-current` — current branch
   - `git log --oneline -5` — recent commits
   - `git status --short` — uncommitted changes
   - `ls -1 .tmp/ 2>/dev/null || echo "(none)"` — existing features
2. **Parse feature name**: Convert `$ARGUMENTS` to kebab-case (e.g., "Lazy Loading" →
   "lazy-loading")
3. **Check existing**: Read `.tmp/<feature-name>/feature.md` if directory exists
4. **Create directory**: `.tmp/<feature-name>/` if it doesn't exist
5. **Create/Update proposal** at `.tmp/<feature-name>/feature.md`:

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

6. **Ask clarifying questions** about requirements if needed

## Important

- `.tmp/` directory should be in `.gitignore` — working documents, not committed
- Each feature has its own directory for all related files (notes, research, etc.)
- Follow the checklist during implementation
- Update all docs after implementation is complete
- Directories are kept after feature completion (manual cleanup when needed)

## Integration

When all checklist items are complete, suggest:

1. `/update-docs` — update documentation to reflect the new feature
2. `/commit` — commit the changes

Feature request: $ARGUMENTS
