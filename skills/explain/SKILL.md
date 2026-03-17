---
name: explain
description:
  Explain code or architecture at the requested depth. Use when user asks to understand how
  something works.
allowed-tools: Read, Grep, Glob
---

Explain the specified code: `$ARGUMENTS`

## Process

1. **Locate** the target (file, function, module, or concept)
2. **Read** the relevant code and its dependencies
3. **Explain** at the appropriate level:
   - **What** it does (behavior)
   - **How** it works (mechanism)
   - **Why** it's designed this way (intent, tradeoffs)

## Depth levels

Adjust based on what the user asks:

- **Quick** ("what does X do?") — 2-3 sentences, behavior only
- **Standard** ("explain X") — what + how, with key code references
- **Deep** ("explain X in detail", "walk me through") — what + how + why, call chains, edge cases

## Rules

- Reference specific lines: `file.ts:42`
- Use code snippets only when they clarify the explanation
- Don't repeat the code back — explain what's not obvious from reading it
- If architecture spans multiple files, show the flow/sequence
- Adapt terminology to the user's level
