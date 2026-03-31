# Framework-Specific Leak Patterns (16.4% of findings)

Framework-specific patterns where missing cleanup depends on the framework's lifecycle model.

Distribution across frameworks (from empirical study of 500 repos):
- React: 62.3% of all findings (34,787 instances)
- Vue: 28.2% (15,750 instances)
- Angular: 9.5% (5,327 instances)

## Vue

| Pattern | Leak condition |
|---|---|
| `onMounted` + side effect | No matching `onUnmounted` for cleanup |
| `watch()` / `watchEffect()` | Return value (stop handle) not captured |
| `addEventListener` in `setup()` / `<script setup>` | No removal in `onUnmounted` |

## React

| Pattern | Leak condition |
|---|---|
| `useEffect` + `addEventListener` | No cleanup return (`return () => ...`) |
| `useEffect` + `setInterval` / `setTimeout` | No cleanup return |
| `useEffect` + `.subscribe()` | No cleanup return |

Missing effect cleanup accounts for 9.3% of all findings. Benchmark: React useEffect listener
leak accumulates ~807 KB over 100 mount/unmount cycles.

## Angular

| Pattern | Leak condition |
|---|---|
| `.subscribe()` | No `.unsubscribe()` in `ngOnDestroy` |
| Component with subscriptions | Missing `ngOnDestroy` entirely |
| `Renderer2.listen()` | Unlisten function not stored or called |

Benchmark: Angular subscribe leak accumulates ~804 KB over 100 cycles.

## Svelte

| Pattern | Leak condition |
|---|---|
| `onMount` | Return value not used for cleanup |
| `addEventListener` | No `onDestroy` removal |
