# Pillar 2 — Atomic Micro-packages

One-liner packages that should be inlined. Each is a potential supply chain attack surface and adds
install overhead (npm requests, tar extraction, version resolution) for trivial logic.

**Single-consumer pattern**: many of these have only one consumer in the ecosystem (e.g.
`shebang-regex` is used solely by `shebang-command`, `onetime` solely by `restore-cursor`,
`cli-boxes` solely by `boxen`). Inlining makes duplication almost free, while packaging makes it
expensive.

Flag if found anywhere in the dependency tree.

| Package           | Equivalent code                                  |
| ----------------- | ------------------------------------------------ |
| `arrify`          | `Array.isArray(x) ? x : [x]`                     |
| `is-windows`      | `process.platform === 'win32'`                   |
| `is-wsl`          | Check `os.release()` for "microsoft"             |
| `is-docker`       | Check `/.dockerenv` or cgroup                    |
| `path-key`        | `process.platform === 'win32' ? 'Path' : 'PATH'` |
| `shebang-regex`   | `/^#!(.*)/`                                      |
| `shebang-command` | Parse shebang line (uses `shebang-regex`)        |
| `slash`           | `path.replace(/\\\\/g, '/')`                     |
| `onetime`         | Closure with a called flag                       |
| `cli-boxes`       | JSON object with box-drawing characters          |
| `strip-eof`       | `str.replace(/\\r?\\n$/, '')`                    |
| `path-exists`     | `fs.existsSync()`                                |
| `make-dir`        | `fs.mkdirSync(p, { recursive: true })`           |
| `pify`            | `util.promisify()`                               |
| `p-try`           | `Promise.resolve().then(fn)`                     |
| `p-finally`       | `promise.finally()`                              |
| `p-is-promise`    | `typeof x?.then === 'function'`                  |
| `is-plain-object` | `Object.getPrototypeOf(x) === Object.prototype`  |
| `clone-regexp`    | `new RegExp(re.source, re.flags)`                |
| `strip-bom`       | `str.replace(/^\\uFEFF/, '')`                    |
| `os-tmpdir`       | `os.tmpdir()`                                    |
| `number-is-nan`   | `Number.isNaN()`                                 |
