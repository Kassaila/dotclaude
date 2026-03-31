---
name: memory-leak-audit
description:
  Audit source code for frontend memory leak patterns — missing cleanup in lifecycle hooks, event
  listeners without removal, timers without clear, subscriptions without unsubscribe, watchers
  without stop handles. Use when reviewing components, after implementing features with side
  effects, or when user asks about memory leaks.
allowed-tools: Grep, Glob, Read
---

Audit the codebase for missing-cleanup patterns that cause memory leaks in frontend components.

## Background

In garbage-collected runtimes, memory leaks occur when code creates reference chains that remain
reachable after a component unmounts. The GC cannot collect objects that are still referenced — even
if the developer intended them to be disposed. Each missing cleanup retains ~8 KB per mount/unmount
cycle, compounding linearly with navigation count.

An empirical study of 500 public repositories found 55,864 missing-cleanup patterns across 714,217
files — 86% of repos had at least one potential leak.

Pattern tables and fix examples are in `references/`:

- `references/leak-patterns.md` — generic patterns (timers, listeners, subscriptions, observers)
- `references/framework-patterns.md` — Vue, React, Angular, Svelte specifics
- `references/fix-reference.md` — one-line fixes and acceptable-finding criteria

## What to scan

Search the target directory (default: `src/`) or `$ARGUMENTS` if provided. Scan `.ts`, `.tsx`,
`.vue`, `.js`, `.jsx`, and `.svelte` files.

## Audit process

1. **Detect framework** — check package.json for vue/react/angular/svelte to prioritize patterns
2. **Scan** — use Grep to find each pattern category from `references/leak-patterns.md` and the
   relevant framework section from `references/framework-patterns.md`
3. **Verify context** — Read flagged files to check if cleanup exists elsewhere in the same
   component (different line, helper function, composable)
4. **Classify risk**:
   - **High**: Pattern in a frequently mounted component (route views, list items, modals, tabs)
   - **Medium**: Pattern in a rarely mounted component or singleton
   - **Low**: Self-completing observable, short-lived timer, or singleton that never unmounts
     (see `references/fix-reference.md` for acceptable-finding criteria)
5. **Report** findings grouped by file

## Output format

```
## Memory Leak Audit Results

Scanned: X files in <directory>
Framework: [detected framework]
Found: Y potential leak patterns

### High Risk

**src/components/Dashboard.vue** (3 patterns)
- Line 42: `setInterval` without `clearInterval` in teardown
- Line 58: `addEventListener('resize', ...)` without `removeEventListener`
- Line 71: `watch()` return value not captured

### Medium Risk

**src/App.vue** (1 pattern)
- Line 15: `addEventListener` without removal (singleton — low accumulation)

### Summary

| Pattern                  | Count | Risk  |
| ------------------------ | ----- | ----- |
| Missing timer cleanup    | 2     | High  |
| Missing listener removal | 2     | Mixed |
| Missing watch stop       | 1     | High  |

### Suggested fixes

[One-line fix for each High-risk finding, from references/fix-reference.md]
```

## Source

Based on [Frontend Memory Leaks: Empirical Study](https://stackinsight.dev/blog/memory-leak-empirical-study/)
by StackInsight.
