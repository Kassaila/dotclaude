---
name: code-review
description:
  Review code for best practices and potential issues. Delegates to specialized reviewer agents. Use
  when user says "review", "code review", "check my code", or asks to review changes before
  committing. TRIGGER when user explicitly asks for a review, says "review this", or uses
  /code-review. DO NOT TRIGGER when user is just reading or explaining code, or asks to refactor.
---

Review code by delegating to specialized reviewer agents.

## Usage

```
/code-review                    # full review of staged changes (all 4 reviewers)
/code-review unstaged           # review unstaged changes
/code-review all                # review all uncommitted changes
/code-review <file>             # review a specific file
/code-review <sha>              # review a specific commit
/code-review security           # run only the security reviewer
/code-review security,perf      # run specific reviewers (comma-separated)
```

## Reviewers

| Agent                  | Role        | Focus                                             |
| ---------------------- | ----------- | ------------------------------------------------- |
| `reviewer-architect`   | Architect   | Patterns, coupling, SOLID, layers, abstraction    |
| `reviewer-senior`      | Senior Dev  | Idioms, types, error handling, edge cases, async  |
| `reviewer-security`    | Security    | Injections, secrets, auth, input validation       |
| `reviewer-performance` | Performance | N+1, allocations, data structures, resource leaks |

## Process

1. **Parse `$ARGUMENTS`** into scope and reviewer selection:
   - **Scope**: `staged` (default) | `unstaged` | `all` | file path | commit SHA
   - **Reviewers**: all 4 by default, or specific ones if named (`security`, `perf`, `arch`,
     `senior`)

2. **Decide how many reviewers to invoke**:
   - Small diff (<50 lines) → `reviewer-senior` only
   - Medium diff (50–500 lines) → all 4 reviewers in parallel
   - Large diff (>500 lines) → all 4 reviewers in parallel, suggest per-file review

3. **Invoke reviewer agents** with the scope description. All run on sonnet in parallel.

4. **Aggregate results**: combine all agent reports into a single output, grouped by priority
   (Critical → Warnings → Suggestions), with reviewer role label on each finding.

## Rules

- Never modify code — read-only review
- The skill is a thin router — all review logic lives in the agents
