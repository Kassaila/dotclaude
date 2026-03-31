# Pillar 3 — Overstayed Ponyfills

Packages that ponyfill features supported in all current LTS engines. These did their job at the
time but should be removed once all target engines support the feature natively.

If `engines.node` in package.json specifies a minimum, use that to filter relevance — only flag
ponyfills for features available in the declared minimum engine version.

Flag if found anywhere in the dependency tree.

| Package | Native equivalent | Supported since |
|---|---|---|
| `globalthis` | `globalThis` | Node 12 (2019) |
| `object.entries` | `Object.entries()` | Node 8 (2017) |
| `object.values` | `Object.values()` | Node 8 (2017) |
| `object.fromentries` | `Object.fromEntries()` | Node 12 (2019) |
| `object.assign` | `Object.assign()` | Node 4 (2015) |
| `object.groupby` | `Object.groupBy()` | Node 22 LTS (2024) |
| `array.prototype.flat` | `Array.prototype.flat()` | Node 11+ / 18 LTS (2019) |
| `array.prototype.flatmap` | `Array.prototype.flatMap()` | Node 11+ / 18 LTS (2019) |
| `array.prototype.find` | `Array.prototype.find()` | Node 4 (2015) |
| `array.prototype.findindex` | `Array.prototype.findIndex()` | Node 4 (2015) |
| `array.prototype.includes` | `Array.prototype.includes()` | Node 6 (2016) |
| `string.prototype.includes` | `String.prototype.includes()` | Node 4 (2015) |
| `string.prototype.startswith` | `String.prototype.startsWith()` | Node 4 (2015) |
| `string.prototype.endswith` | `String.prototype.endsWith()` | Node 4 (2015) |
| `string.prototype.padstart` | `String.prototype.padStart()` | Node 8 (2017) |
| `string.prototype.padend` | `String.prototype.padEnd()` | Node 8 (2017) |
| `string.prototype.trimstart` | `String.prototype.trimStart()` | Node 10 (2019) |
| `string.prototype.trimend` | `String.prototype.trimEnd()` | Node 10 (2019) |
| `string.prototype.replaceall` | `String.prototype.replaceAll()` | Node 15+ / 18 LTS (2021) |
| `string.prototype.matchall` | `String.prototype.matchAll()` | Node 12 (2020) |
| `promise.allsettled` | `Promise.allSettled()` | Node 12.9 (2020) |
| `promise.any` | `Promise.any()` | Node 15+ / 18 LTS (2021) |
| `indexof` | `Array.prototype.indexOf()` | ES5 (2009) |
| `is-nan` | `Number.isNaN()` | Node 4 (2015) |
| `regexp.prototype.flags` | `RegExp.prototype.flags` | Node 6 (2015) |
| `es6-promise` | `Promise` | Node 4 (2015) |
| `es6-map` | `Map` | Node 4 (2015) |
| `es6-set` | `Set` | Node 4 (2015) |
| `es6-symbol` | `Symbol` | Node 4 (2015) |
| `es6-weak-map` | `WeakMap` | Node 4 (2015) |
| `weakref` | `WeakRef` | Node 14.6 (2021) |
| `structured-clone` | `structuredClone()` | Node 18 LTS (2022) |
