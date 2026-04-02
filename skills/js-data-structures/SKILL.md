---
name: js-data-structures
description:
  Implement and use data structures in JavaScript. Use when working with queues, stacks, heaps,
  priority queues, caches, LRU, tries, circular buffers, bloom filters, union-find, bidirectional
  maps, counters, or when the user asks about choosing between Map/Object/Set/Array or
  grouping/counting/deduplication patterns.
---

# Data Structures (JavaScript)

## Use a library unless you can't afford the dependency

A good data-structure library should be tree-shakable, lightweight, typed, and SSR-safe. This skill
recommends `mnemonist` (collections) and `graphology` (graphs) — each reference shows both the
library API and a manual fallback for zero-dep contexts.

## Map vs Object, Set vs Array

- Prefer **Map** when keys are non-string (numbers, objects), when you add/remove entries often,
  when you need `.size`
- Prefer **Object** when keys are string/symbol, the shape is static and known at creation, or you
  need JSON serialization
- Prefer **Set** when uniqueness matters or you need fast `.has()` lookups
- Prefer **Array** when order and duplicates matter; when have fixed size array; need index access

## Data structure references

Load the relevant reference when the user needs a specific data structure:

### Classics

- **Heap / Priority Queue** — see `references/heap.md`. FE: top-N results, notification priority.
  BE: task scheduling, Dijkstra, merge K streams.
- **Queue** — see `references/queue.md`. FE: event batching, animation queues. BE: job queues,
  webhook delivery, request throttling.
- **Stack** — see `references/stack.md`. FE: undo/redo, modal stacking, navigation. BE: expression
  parsing, DFS, middleware unwinding.
- **LRU Cache** — see `references/lru-cache.md`. FE: API response cache, memoized selectors. BE: DB
  query cache, session store, DNS cache.
- **Trie** — see `references/trie.md`. FE: autocomplete, command palette, tag search. BE: URL
  routing, IP prefix matching, word filtering.
- **Circular Buffer** — see `references/circular-buffer.md`. FE: canvas trails, real-time charts,
  FPS sampling. BE: rolling logs, metrics window, streaming ingestion.

### Collections

- **BiMap** — see `references/bimap.md`. FE: keybinding↔action, locale↔language. BE: ID↔slug,
  MIME↔extension, user↔socket.
- **DefaultMap** — see `references/default-map.md`. FE: grouping UI elements, error collection. BE:
  log aggregation, adjacency lists, request grouping.
- **MultiMap** — see `references/multimap.md`. FE: event listeners, shortcut groups. BE: HTTP
  headers, role↔permissions, pub/sub topics.
- **MultiSet (Bag)** — see `references/multiset.md`. FE: vote tallying, filter tag counts, cart
  quantities. BE: word frequency, log histogram, API usage metering.

### Specialized

- **Bloom Filter** — see `references/bloom-filter.md`. FE: username pre-check, "already seen"
  filter. BE: URL deduplication, cache pre-check, spam filtering.
- **Disjoint Set (Union-Find)** — see `references/disjoint-set.md`. FE: flood fill, group selection
  in editors. BE: connected components, cycle detection, network partitions.
- **Graph** — see `references/graph.md`. FE: relationship UIs, dependency visualization, knowledge
  explorers. BE: shortest path, community detection, topological sort, centrality.

## Sources

- **mnemonist** — [repo](https://github.com/Yomguithereal/mnemonist) ·
  [docs](https://yomguithereal.github.io/mnemonist/) ·
  [npm](https://www.npmjs.com/package/mnemonist)
- **graphology** — [repo](https://github.com/graphology/graphology) ·
  [docs](https://graphology.github.io/) · [npm](https://www.npmjs.com/package/graphology)
