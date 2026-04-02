---
name: commit
description:
  Create a git commit. Analyzes changes, proposes a commit message and files to stage, asks the user
  to confirm, then executes git add + git commit. Use when user says "commit", "commit this", "make
  a commit", or asks to commit changes. This is the go-to skill for committing — always prefer it
  over manual git commands.
allowed-tools:
  Bash(git status*), Bash(git diff*), Bash(git log*), Bash(git add *), Bash(git commit *)
---

Create a git commit through a propose-confirm-execute flow.

## Step 1: Analyze

1. Run `git status` to see changed/untracked files
2. Run `git diff --staged` and `git diff` to understand the changes
3. Run `git log --oneline -5` to match the project's commit style

If there are no changes, tell the user and stop.

## Step 2: Propose

Present the proposal to the user:

### Files to stage

List files grouped logically. If changes span multiple concerns, suggest splitting into separate
commits and explain why.

```
git add <file1> <file2> ...
```

### Commit message

Follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

Scope detection: infer from file paths (`src/auth/` → `auth`) or use the argument if provided
(`/commit auth`). Omit scope if changes span multiple areas.

## Step 3: Confirm

Ask the user to confirm before proceeding. They may:

- Approve as-is
- Edit the message or file list
- Cancel

Do NOT proceed without explicit confirmation.

## Step 4: Execute

Once confirmed:

1. `git add` the agreed files
2. `git commit` with the agreed message (use HEREDOC for multiline messages)

```bash
git add <files>
git commit -m "$(cat <<'EOF'
<message>
EOF
)"
```

Show the resulting commit hash and summary.

## Rules

- Warn if sensitive files (.env, credentials, secrets) are in the changeset — do not stage them
  unless the user explicitly confirms
- Never use `git add -A` or `git add .` — always stage specific files
- Never push — that's the user's responsibility
- Never skip hooks (no `--no-verify`)
- Never amend previous commits unless the user explicitly asks
- Add Co-Authored-By trailer only if the user explicitly asks for it
