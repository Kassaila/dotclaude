---
name: commit-proposal
description:
  Suggest commit message and files to include. Does NOT create the commit — user commits manually.
  Use when user asks for commit help or after completing a task.
allowed-tools: Bash(git status*), Bash(git diff*), Bash(git log*)
---

Analyze current changes and suggest a commit.

## Steps

1. Run `git status` to see changed/untracked files
2. Run `git diff --staged` and `git diff` to understand the changes
3. Run `git log --oneline -5` to match the project's commit style

## Output

### Files to include

List which files should be staged, grouped logically. If changes span multiple concerns, suggest
splitting into separate commits.

```
git add <file1> <file2> ...
```

### Suggested message

Use conventional commits format:

```
<type>(<scope>): <short description>

<optional body — what and why>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`, `ci`, `build`

## Rules

- NEVER create commits — only suggest
- NEVER run `git add` or `git commit`
- If there are no changes, say so
- Warn if sensitive files (.env, credentials) are in the changeset
- If changes are large/mixed, suggest splitting into multiple commits
