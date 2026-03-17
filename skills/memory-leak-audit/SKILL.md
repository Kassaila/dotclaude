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
cycle (for a typical small-to-medium component), compounding linearly with navigation count.

## What to scan

Search the target directory (default: `src/`) or `$ARGUMENTS` if provided. Scan `.ts`, `.tsx`,
`.vue`, `.js`, `.jsx`, and `.svelte` files.

## Leak patterns to detect

### Priority 1 — Timers (43.9% of real-world findings)

- `setTimeout` without `clearTimeout` in teardown hook
- `setInterval` without `clearInterval` in teardown hook

### Priority 2 — Event listeners (19.0%)

- `addEventListener` without matching `removeEventListener` in teardown
- `window.addEventListener` / `document.addEventListener` without removal

### Priority 3 — Subscriptions (13.9%)

- `.subscribe()` without `.unsubscribe()` or `takeUntil` pattern
- Event bus `.on()` without `.off()` in teardown

### Priority 4 — Framework-specific (16.4%)

**Vue:**

- `onMounted` without matching `onUnmounted` for cleanup
- `watch()` / `watchEffect()` return value not captured (stop handle discarded)
- Manual `addEventListener` in `setup()` / `<script setup>` without removal in `onUnmounted`

**React:**

- `useEffect` with `addEventListener` / `setInterval` / `setTimeout` / `.subscribe()` but no
  cleanup return (`return () => ...`)

**Angular:**

- `.subscribe()` without `.unsubscribe()` in `ngOnDestroy`
- Missing `ngOnDestroy` in components with subscriptions
- `Renderer2.listen()` without stored unlisten function

**Svelte:**

- `onMount` return value not used for cleanup
- Manual `addEventListener` without `onDestroy` removal

### Priority 5 — Observers and RAF (3.6%)

- `IntersectionObserver` / `MutationObserver` / `ResizeObserver` without `.disconnect()`
- `requestAnimationFrame` without `cancelAnimationFrame`

## Audit process

1. **Detect framework** — check package.json for vue/react/angular/svelte to prioritize patterns
2. **Scan** — use Grep to find each pattern category in the target files
3. **Verify context** — Read flagged files to check if cleanup exists elsewhere in the same
   component (different line, helper function, composable)
4. **Classify risk**:
   - **High**: Pattern in a frequently mounted component (route views, list items, modals, tabs)
   - **Medium**: Pattern in a rarely mounted component or singleton
   - **Low**: Self-completing observable, short-lived timer, or singleton that never unmounts
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

[One-line fix for each High-risk finding]
```

## Fix reference

For each pattern, the fix is typically one line:

- **Timer**: `onUnmounted(() => clearInterval(id))` / `return () => clearTimeout(id)`
- **Listener**: `onUnmounted(() => removeEventListener('event', handler))`
- **Watch**: `const stop = watch(...); onUnmounted(() => stop())`
- **Subscription**: `.pipe(takeUntil(destroy$))` or `onUnmounted(() => sub.unsubscribe())`
- **Observer**: `onUnmounted(() => observer.disconnect())`
- **RAF**: `onUnmounted(() => cancelAnimationFrame(frameId))`

## When findings are acceptable

Not every match is a bug. Mark as **Low risk** and note the reason:

- Singletons that mount once and never unmount (root App component)
- Short-lived timers (`setTimeout` < 100ms in a long-lived component)
- Finite observables that auto-complete (HTTP requests)
- Self-cancelling timers that clear themselves on response
