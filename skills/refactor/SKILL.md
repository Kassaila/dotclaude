---
name: refactor
description:
  Refactor a file or function with explanation. Use when user asks to clean up, simplify, or
  restructure code.
allowed-tools: Read, Edit, Grep, Glob
---

Refactor the specified code: `$ARGUMENTS`

## Process

1. **Read** the target file/function
2. **Analyze** what can be improved:
   - Duplicated logic that can be extracted
   - Overly complex conditions that can be simplified
   - Poor naming that obscures intent
   - Functions doing too many things (SRP violations)
   - Unnecessary abstractions or indirection
   - Dead code
3. **Explain** what you'll change and why before making edits
4. **Refactor** — apply changes
5. **Summary** — list what changed

## Rules

- Explain each change with reasoning
- Preserve external behavior — no functional changes unless explicitly asked
- Don't add features, types, comments, or docs beyond what's needed
- Keep it simple — don't replace one complexity with another
- If the code is already clean, say so

## Integration

- `/refactor review <target>` — after refactoring, automatically invoke `/code-review` on the
  changed files to verify no regressions were introduced
