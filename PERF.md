# Performance of the Jac rewrite

This compares three builds of the server on the same inputs:

- **original**: the TypeScript at `39a87d2`, before any rewrite.
- **Jac before**: `bca3b8b`, the rewrite as `neojac-deslop` left it.
- **Jac after**: this branch (`neojac-perf`).

Everything was measured on 2026-11-25 with neojac 0.5.1 on a shared 20-core Linux machine. The load
average is given with each table. Every comparison alternates the builds, changing which goes first
each round, and reports medians. The scripts are in [`perf/`](perf/).

## What runs where

All the Jac is in one space, `server`, which is a **node** space. Its 23 Jac modules are compiled to
JavaScript and run on Node next to the server's TypeScript. **No Jac in this repo runs in a native
space, so none of it is compiled to machine code.** The `cli`, `client` and `shared` trees hold no
Jac.

Every build runs on the same interpreter: neojac's Node 26.13.0, with the server started under
`tsx src/index.ts`. Both dependency trees resolve to the same package versions. The original's
`node_modules` were installed with `neojac npm ci` in its own checkout, and nothing was committed
there. The Jac builds run from the tree `neojac npm` lays out in `.jac/test/spaces/server/server`.

Behaviour is the same:
- Every endpoint below returns the same body on all three builds. Ids, timestamps and latencies are
  masked before comparing.
- The function benchmark's fingerprint of 11 functions' outputs is identical across all three.
- The server suite passes everywhere: 445 files, with 5795 tests passing on the original and 5796 on
  the Jac. The extra test is a null case the rewrite added.

## Before and after

### Server endpoints

A mock OpenAI-compatible upstream on loopback, with a custom provider pointing at it, so every chat
request takes the full route: auth, routing, the fallback loop, the upstream call and the analytics
write. Each figure is the median over 5 rounds of 300–400 sequential requests (20 logins). Run B
uses copies of both Jac trees in `/tmp`, so they sit at the same path depth (see start-up).

| metric | original | Jac before | Jac after | before/original | after/original |
|---|---:|---:|---:|---:|---:|
| **Run A**, load 4.7–6.0 | | | | | |
| `POST /v1/chat/completions` µs/req | 2490 | 2383 | 2322 | 0.96x | 0.93x |
| `POST /v1/chat/completions` stream µs/req | 2379 | 2535 | 2284 | 1.07x | 0.96x |
| `POST /v1/messages` µs/req | 2283 | 2412 | 2231 | 1.06x | 0.98x |
| `GET /api/auth/me` µs/req | 284 | 336 | 321 | 1.18x | 1.13x |
| `GET /v1/models` µs/req | 1246 | 1259 | 1231 | 1.01x | 0.99x |
| `GET /api/models` µs/req | 1790 | 1803 | 1803 | 1.01x | 1.01x |
| `GET /api/analytics/summary` µs/req | 1628 | 1683 | 1608 | 1.03x | 0.99x |
| `POST /api/auth/login` µs/req (scrypt) | 27833 | 27767 | 27685 | 1.00x | 0.99x |
| chat, 16 concurrent, req/s | 484 | 489 | 511 | 1.01x | 1.06x |
| **Run B**, load 8.8–9.2 | | | | | |
| `POST /v1/chat/completions` µs/req | 2720 | 3044 | 2846 | 1.12x | 1.05x |
| `POST /v1/chat/completions` stream µs/req | 2711 | 2957 | 2766 | 1.09x | 1.02x |
| `POST /v1/messages` µs/req | 2608 | 2727 | 2646 | 1.05x | 1.01x |
| `GET /api/auth/me` µs/req | 302 | 365 | 334 | 1.21x | 1.10x |
| chat, 16 concurrent, req/s | 416 | 381 | 403 | 0.92x | 0.97x |
| **Run C**, final commit, original vs Jac only, load 6.1–8.2 | | | | | |
| `POST /v1/chat/completions` µs/req | 2680 | – | 2813 | – | 1.05x |
| `POST /v1/chat/completions` stream µs/req | 2541 | – | 2765 | – | 1.09x |
| `POST /v1/messages` µs/req | 2437 | – | 2588 | – | 1.06x |
| `GET /api/auth/me` µs/req | 290 | – | 336 | – | 1.16x |
| chat, 16 concurrent, req/s | 430 | – | 407 | – | 0.95x |

`GET /api/ping` (no Jac on its path) varied from 0.82x to 1.01x between runs. That is about the
size of the noise. Runs A and B measured the code before `ca6b062`, which saves about 2 µs a request
in the served-model check. Run C measured the final commit. The same build lands 5–10% apart from
run to run against the original, so the honest reading is that chat and messages are now within
about 0–9% of the original, where they were 5–12% slower before this work.

### Start-up

Wall time from spawning the server to its first `200` on `/api/ping`. "Cold" is a fresh database
(migrations, seeding, the admin account's scrypt); "warm" is a restart on that database.

| metric | original | Jac before | Jac after | before/original | after/original |
|---|---:|---:|---:|---:|---:|
| warm, 11 rounds, Jac trees in `/tmp` (load 7–9) | 575 ms | 633 ms | 641 ms | 1.10x | 1.11x |
| warm, 11 rounds, "after" in the repo (load 6–10) | 562 ms | 622 ms | 636 ms | 1.11x | 1.13x |
| cold, run B above (5 rounds) | 683 ms | 763 ms | 758 ms | 1.12x | 1.11x |
| warm, run A above (5 rounds) | 565 ms | 624 ms | 641 ms | 1.11x | 1.14x |

The Jac starts about 60 ms slower, and this work does not change that. Importing the app graph
alone, before and after differ by less than the noise when both trees are in `/tmp` (8 rounds: 469
vs 467 ms). The same code laid out in the repo's own `.jac/` imports about 12 ms slower than in
`/tmp`, with an identical syscall trace, so the location affects the "after in the repo" row.

### Test suite

The server's vitest suite, run as its `test` script runs it (`--pool=forks --fileParallelism=false`).

| run | load | original | Jac before | Jac after |
|---|---:|---:|---:|---:|
| 1 | ~20 | 327 s | 360 s | 349 s |
| 2 | ~5 | 260 s | 280 s | 284 s |
| earlier pair, no "after" yet | 6–10 | 279 s | 286 s | – |
| sum of per-file test time, run 2 | | 131.4 s | 131.4 s | 132.5 s |

The Jac's suite takes 3–10% longer. All of it is outside the tests themselves, whose summed time is
equal. It is import: vitest counted 1006 module evaluations, 88 s, on the original against 1402,
102 s, on the Jac (see the boot-module limit below). The CLI (186 tests) and client (524 tests)
suites hold no Jac and are unchanged.

### Per function

The hot functions the rewrite turned into Jac, each called directly from TypeScript as the server
calls it, on a file database (`perf/micro.mts`). Medians of 3 alternated runs, load 7–9.

| function (calls per chat request) | original µs | Jac before µs | Jac after µs | before/original | after/original |
|---|---:|---:|---:|---:|---:|
| `logRequest` (1) | 715.7 | 790.7 | 742.1 | 1.1x | 1.0x |
| `persistRequestAttempts` (1) | 146.8 | 174.8 | 150.6 | 1.2x | 1.0x |
| `runWithRequestTrace` + get (1) | 0.26 | 3.61 | 2.15 | 14x | 8.4x |
| `resolveAuth` (1) | 22.0 | 35.9 | 28.0 | 1.6x | 1.3x |
| `maybeInjectSystemDate` (1) | 7.1 | 12.2 | 11.4 | 1.7x | 1.6x |
| `deriveTaskType` (1) | 0.08 | 11.70 | 1.46 | 144x | 18x |
| `getEndpointTimeBudgetMs` (per attempt) | 21.1 | 36.5 | 29.5 | 1.7x | 1.4x |
| `applyTokenBudget` (1) | 7.2 | 13.9 | 10.5 | 1.9x | 1.5x |
| `newBreaker` + `recordBreakerFailure` | 8.3 | 14.7 | 11.7 | 1.8x | 1.4x |
| `observeServedModel` (1) | 0.34 | 4.22 | 2.18 ¹ | 12x | 5x |
| `routeOutputBudget` (1) | 0.03 | 1.21 | 1.21 | 37x | 37x |
| `prependSystemPrompt` | 0.10 | 0.91 | 0.73 | 9x | 7x |
| `summarizeAttemptError` (on failure) | 1.76 | 3.45 | 3.03 ¹ | 2.0x | 1.7x |
| `validateToolArguments` (with tools) | 0.26 | 2.81 | 1.85 | 11x | 7x |
| `stableStringify` (with tools) | 1.37 | 23.60 | 5.72 | 17x | 4.2x |
| `convertDocumentBlock` (document blocks) | 1.39 | 7.56 | 5.35 | 5.4x | 3.8x |
| `validateSession` (each dashboard request) | 21.7 | 36.3 | 30.1 | 1.7x | 1.4x |
| `loadConfig` (once) | 2.4 | 14.6 | 6.0 | 6.1x | 2.5x |

¹ After the last commit (`String.prototype` calls), measured as 3 alternated runs against the
original alone at load 7–9 (original 0.46 and 1.76 µs in those runs).

Summed over one chat request, the Jac's cost above the TypeScript went from about 170 µs to about
64 µs. At 2.3–2.7 ms a request, the remaining 64 µs is 2–3% and the 106 µs saved about 4%. That is
consistent with the endpoint tables moving from 1.05–1.12x to 0.93–1.09x. The run-to-run noise is
about as large as the change.

## Why the Jac was slower, and what changed

Profiles of the server under 3000 chat requests (`perf/profile.sh`, `perf/prof*.mjs`) put the gap
in neojac's JavaScript runtime (`.jac/@jac/core.js`), where the Jac modules call it. (A V8 profile
charges native addon time, such as better-sqlite3's `run` and `prepare`, to the JS frame that
calls it. So much of the runtime's `call` self time is SQLite work the TypeScript also does, not
overhead.) `perf/prims.mjs` prices each runtime primitive against the JavaScript it stands for:

| what the Jac compiles to | cost | plain JavaScript |
|---|---:|---:|
| a nested `def` handed to JavaScript, per call (`titled`/`faced`/`named`, then a JS face) | 5.9 µs | – |
| a comprehension, `any(...)` or `reversed(...)` over a generator, per call (`gen_fn`) | 3.8 µs | 5 ns loop |
| `Object.fromEntries(fields.items())`, the old `jshost.plain` | 1.5 µs | 9 ns literal |
| the runtime's own dict-to-object conversion (`$j.plain`) | 0.10 µs | |
| a tuple built and unpacked | 0.38 µs | |
| a TypeScript call of a Jac function through its forwarder's face | 0.35 µs | 3.6 ns |
| a method call on a value typed `any` (`callattr`) | 0.10 µs | 1.6 ns |
| a property read on a value typed `any` (`getattr`) | 0.03 µs | 3.8 ns |

The first four are code shapes, and the commits on this branch remove them wherever they run per
request:

- **`jshost.plain`** builds its object with the runtime's conversion (`globalThis.Object(fields)`),
  15x cheaper. Every module returns its results through it: guardrails, system-prompt,
  attempt-trace, auth's session user, anthropic-documents, tool-validate, config.
- **`jshost.sub`** keeps each compiled `RegExp` instead of compiling one per call.
- **`logRequest` and `persistRequestAttempts`** handed `db.transaction` a nested `def`, which was
  made and given a JS face on every call. The transaction bodies are now module functions that take
  their values as arguments. The tuple unpacking in the hour bucket and the settings counters is
  gone.
- **`deriveTaskType`, system-date's checks, `stableStringify`, anthropic-documents' text join and
  ttfb-budget's `readConfig`** used comprehensions, `any()` over generators, `reversed(list(...))`,
  a nested `def` and a dict comprehension. They are now loops and module functions.
- **JavaScript's string methods on values typed `any`** (`trim`, `toLowerCase`, `slice`,
  `lastIndexOf`, `trimEnd`) are called as `globalThis.String.prototype.trim.call(s)`. That compiles
  to the JavaScript call itself, while `s.trim()` goes through `callattr`, which has no method of
  its own for these and takes its generic path. Lengths and slices stay in UTF-16 units, as in the
  TypeScript; a Jac `str`'s `len()` and `[:n]` count code points, which would cut long error
  messages at a different place. This is in served-model, error-redaction and request-log.
- **error-redaction** reads its pattern table as a typed `list[tuple[any, str]]` by index. That
  compiles to plain `[0]`/`[1]`, where a list typed `list[any]` goes through `getitem` and
  unpacking goes through the runtime. This only gets back to the starting cost: an earlier indexed
  `list[any]` version had made it slower.

What is left is mostly the last three rows of that table. Each TypeScript→Jac call pays the face,
and each method call on a JavaScript value pays `callattr`. Code shape can't remove either of
those (see the limits below).

What was tried and dropped:
- Typing the database handle with the TypeScript interface (`db: Db`, wired from `db/types`).
  Calls on it still compile to `callattr`.
- Reading `process.env` through `globalThis.process.env[k]`. It still compiles to `getitem`, and
  `getitem`'s time there is Node's own environment lookup, which the TypeScript pays too.
- Deferring tool-validate's Ajv. Constructing it is only 3 ms. Its 17–20 ms `require` cannot be
  deferred without the module's own URL (see `js_meta` below).

## Where neojac blocks a speed-up

### 1. No native space can serve the server's hot functions

**(a) An app running a native and a node space does not build.** A project with three files:

```
# jac.toml
[project]
name = "repro"

# fast.jac
def:pub add(a: int, b: int) -> int {
    return a + b;
}

# web.jac
async def:pub twice(x: int) -> int {
    return await add(x, x);
}

# archwire.jac
graph layers {
    layer all { *; }
}
graph spaces {
    space fast: native { fast; }
    space web: node { web; }
    app both { run fast, web; }
}
graph import {
    fast ++> web { add }
}
```

`neojac build both` fails, blaming a file inside neojac itself:

```
jac.toml:1:1: error[E2231]: '/home/<user>/.neojac/0.5.1/lib/node/crates/Cargo.toml' is a module of
the project 'repro', and no archwire.jac governs it: ...
```

**(b) Even where it builds, a crossing does not fit the call sites.** Written as a plain
`def:pub twice(x: int) -> int { return add(x, x); }`, the same `web.jac` fails with
`error[E1002]: cannot return Coroutine[any, any, int] from a function declared to return int`. A
node space's call into a native space is awaited, and in one process it is still "serialized as a
request is" (`neojac docs apps/crossings`). The server calls `logRequest`, `deriveTaskType`,
`applyTokenBudget` and the rest synchronously from TypeScript. So these functions would become
async and serialized: a change in behaviour, and per-call costs well above the microseconds they
take now.

**(c)** neojac's docs also refuse (E5090) "a node space whose npm tree is a member of a workspace"
in a native app's process. `server` is a member of the root workspace.

### 2. A node space cannot call JavaScript directly

neojac's `js` module offers `js_method(o, name, ...)` (a plain `o[name](...)`), `JsNull` and
`js_meta()`. Importing it in a project's node space fails, even in the smallest project:

```
# jac.toml:     [project]  name = "repro"
# archwire.jac: graph layers { layer all { *; } }
#               graph spaces { space svc: node { svc; } app svc { run svc; } }
# svc.jac:
import from js { JsNull }

def:pub nothing -> any {
    return JsNull;
}
```

```
$ neojac check
jac.toml:1:1: error[E2231]: '/home/<user>/.neojac/0.5.1/lib/node/crates/Cargo.toml' is a module of
the project 'repro', and no archwire.jac governs it: ...
```

TypeScript declaration types are not applied to calls (`neojac docs interop/npm`, "Types are not
checked"). A value from TypeScript is therefore `any`, and every method call on it goes through
`callattr`, about 100 ns against about 2 ns. For example, `db: Db = getDb(); db.prepare(sql)`
still compiles to `$j.callattr(db, "prepare", [sql])`. The only direct calls come from expressions
rooted at `globalThis`, which is how the modules reach `Number`, `String.prototype.replace` and the
like. Without `js_meta()` a module also cannot `createRequire` from its own URL, so it cannot defer
loading a package like Ajv.

### 3. Each TypeScript→Jac call pays a face, about 0.35 µs

Each forwarder exports `$js_fn($m.fn)`. A call goes through `written`'s runner: it copies the
arguments with `from_js`, binds each parameter by its kind, and converts the result with `plain`.
This is why one-line functions like `routeOutputBudget` (0.03 → 1.21 µs) and `prependSystemPrompt`
stay 7–40x their TypeScript, though they are a small absolute cost. Nothing in a Jac source selects
a cheaper face. That is why `4e84fc1` returned the router's per-candidate helpers to TypeScript.

The face's cost grows with its arguments. `from_js` walks each array argument and every array
inside it, so a function taking the request's `messages` pays for the conversation's length on every
call. Profiled with only the default `off` mode's setting read, `maybeInjectSystemDate` (11.4 µs vs
7.1 µs) and `validateSession` (30 µs vs 22 µs) spend nearly all of their excess in the face (`run`,
`from_js`) and the runtime's dispatch, not in code the Jac source controls.

### 4. The boot module loads every Jac module of the space

Every forwarder imports the space's `__boot.mjs`, which imports all 23 Jac modules and so their
TypeScript and npm dependencies: the database layer, better-sqlite3, Ajv. In the original, a test
or a process that imports `lib/error-redaction` loads that module in **1 ms**. In the Jac tree the
same import takes **95–101 ms** (`perf/imp1.mts`, 3 runs each, also for `task-type` and
`guardrails`). Across the 445 isolated test files this is the suite's extra ~400 module
evaluations and its 3–10%. No Jac source or `jac.toml` setting makes the boot lazy.

### 5. The laid tree costs start-up about 60 ms

Each Jac module becomes two modules (the forwarder `.ts` and the emitted `.mjs`), plus the runtime
(`core.js`, 181 KB, 5.5 ms to load on its own) and the boot module. tsx probes each emitted `.mjs`
specifier as `.mts`, `.mjs.ts`, `/index.json` and so on before finding it. Importing the app makes
12 529 file-status calls in the Jac tree against 6 405 in the original. Many are under
`.jac/test/spaces/.jac/...`, a directory that does not exist. The app graph's import takes about
65 ms longer, spread over Node's and tsx's resolvers, while the server's own CPU is the same (812
vs 815 ms). The layout and the specifiers are neojac's.

### 6. Not speed, but in the way of verifying

- `neojac test` stops before the server suite with `neojac: the space of the npm tree server does
  not build` and 289 errors (E2224 for each `.jac` and its forwarder `.ts`, E1147, E2097). The same
  happens on `bca3b8b`, so it predates this work. The suite was run as `cd server && neojac npm
  test`, which passes: 445 files, 5796 passed, 6 skipped.
- The root suite's `dev-bootstrap` tests fail under neojac's Node: `scripts/dev-bootstrap.sh`
  requires Node `<25.0.0`, and neojac ships 26.13.0. The hooks suite passes (9/9).

## Reproducing

`perf/` holds the harness. Set `ORIG` to a checkout of `39a87d2` with its packages installed
(`neojac npm ci`), and `BEFORE` to a laid tree of the commit to compare against. Start
`neojac node perf/mock-upstream.mjs 4599` first. Then:

- `neojac node perf/bench.mjs 5 orig=$ORIG/server:4601 jac=.jac/test/spaces/server/server:4602`:
  start-up and endpoints, with an output check.
- `neojac node perf/startup.mjs 11 orig=$ORIG/server jac=.jac/test/spaces/server/server`
- `perf/micro-cmp.sh 3`: per function, with a fingerprint of the outputs.
- `perf/suite-json.sh <server-dir> <out.json>`, then `perf/cmpsuite.mjs`: the suite, per file.
- `perf/profile.sh <label> <server-dir> <requests> [chat|stream|messages]`, then `perf/prof.mjs`,
  `perf/prof2.mjs`, `perf/busy.mjs` or `perf/pdiff.mjs`: CPU profiles.
- `perf/prims.mjs`, run under tsx: the runtime primitives.
