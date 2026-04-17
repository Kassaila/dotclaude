---
name: commit
description:
  Create a git commit or suggest a commit message. Analyzes changes, proposes a commit message and
  files to stage, asks the user to confirm, then executes git add + git commit. Use when user says
  "commit", "commit this", "make a commit", or asks to commit changes. When argument is "propose" or
  user asks for commit help without wanting to execute — run in proposal-only mode (analyze +
  suggest, no git add/commit). This is the go-to skill for committing — always prefer it over manual
  git commands.
allowed-tools:
  Bash(git status*), Bash(git diff*), Bash(git log*), Bash(git add *), Bash(git commit *)
---

Create a git commit through a propose-confirm-execute flow.

## Modes

- **Full mode** (default): Analyze → Propose → Confirm → Execute
- **Proposal mode** (`/commit propose`): Analyze → Propose → Stop. Does NOT stage or commit. Use
  when user asks for commit help, wants to review what to commit, or says "suggest a commit".
- **Review mode** (`/commit review`): Analyze → Review → Propose → Confirm → Execute. Runs
  `/code-review staged` before proposing — catches issues before they enter history.

## Step 1: Analyze

1. Run `git status` to see changed/untracked files
2. Run `git diff --staged` and `git diff` to understand the changes
3. Run `git log --oneline -5` to match the project's commit style

If there are no changes, tell the user and stop.

## Step 1.5: Review (only in review mode)

In **review mode**: invoke `/code-review staged` and present findings. If there are Critical issues,
ask the user whether to fix them before committing or proceed anyway.

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

## Step 3: Confirm (skip in proposal mode)

In **proposal mode**: stop here. Show the suggested `git add` and commit message, then tell the user
they can copy and run manually or use `/commit` to execute.

In **full mode**: ask the user to confirm before proceeding. They may:

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
