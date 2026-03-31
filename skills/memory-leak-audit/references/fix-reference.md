# Fix Reference

## One-line fixes by pattern

| Pattern | Fix |
|---|---|
| Timer | `onUnmounted(() => clearInterval(id))` / `return () => clearTimeout(id)` |
| Listener | `onUnmounted(() => removeEventListener('event', handler))` |
| Watch | `const stop = watch(...); onUnmounted(() => stop())` |
| Subscription | `.pipe(takeUntil(destroy$))` or `onUnmounted(() => sub.unsubscribe())` |
| Observer | `onUnmounted(() => observer.disconnect())` |
| RAF | `onUnmounted(() => cancelAnimationFrame(frameId))` |

## When findings are acceptable

Not every match is a bug. Mark as **Low risk** and note the reason:

- **Singletons** that mount once and never unmount (root App component)
- **Short-lived timers** — `setTimeout` < 100ms in a long-lived component
- **Finite observables** that auto-complete (HTTP requests)
- **Self-cancelling timers** that clear themselves on response
