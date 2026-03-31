# Generic Leak Patterns

Missing-cleanup patterns that cause memory leaks in frontend components. Ordered by real-world
frequency from an empirical study of 500 public repositories (714,217 files scanned, 55,864
missing-cleanup patterns found, 86% of repos had at least one potential leak).

Each missing cleanup retains ~8 KB per mount/unmount cycle, compounding linearly with navigation
count. At 3 concurrent leaking patterns, ~2.4 MB accumulates over 100 navigation cycles. Mobile
browsers terminate tabs at 80-120 MB (iOS), making extended sessions vulnerable.

## Priority 1 — Timers (43.9% of findings)

| Pattern | Leak condition |
|---|---|
| `setTimeout` | No `clearTimeout` in teardown hook |
| `setInterval` | No `clearInterval` in teardown hook |

## Priority 2 — Event listeners (19.0%)

| Pattern | Leak condition |
|---|---|
| `addEventListener` | No matching `removeEventListener` in teardown |
| `window.addEventListener` | No removal in teardown |
| `document.addEventListener` | No removal in teardown |

## Priority 3 — Subscriptions (13.9%)

| Pattern | Leak condition |
|---|---|
| `.subscribe()` | No `.unsubscribe()` or `takeUntil` pattern |
| Event bus `.on()` | No `.off()` in teardown |

## Priority 5 — Observers and RAF (3.6%)

| Pattern | Leak condition |
|---|---|
| `IntersectionObserver` | No `.disconnect()` in teardown |
| `MutationObserver` | No `.disconnect()` in teardown |
| `ResizeObserver` | No `.disconnect()` in teardown |
| `requestAnimationFrame` | No `cancelAnimationFrame` in teardown |
