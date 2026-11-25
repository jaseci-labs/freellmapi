// prims.mjs: cost of neojac 0.5.1's JS-host runtime primitives against the plain JavaScript they stand for.
const J = new URL('../.jac/test/spaces/server/server/.jac/', import.meta.url).pathname;
const $j = await import(J + '@jac/core.js');
const jh = await import(J + 'server/src/lib/jshost.mjs');
await import(J + '__boot.mjs'); jh.$start();
const o = { n: 1, text: 'hello', m(a, b) { return a + b; } };
const bench = (name, f, n = 2e6) => { for (let i = 0; i < 1e5; i++) f(); const t = process.hrtime.bigint(); for (let i = 0; i < n; i++) f(); console.log(name.padEnd(46), (Number(process.hrtime.bigint() - t) / n).toFixed(1), 'ns'); };
let sink;
bench('o.m(1,2) direct', () => { sink = o.m(1, 2); });
bench('$j.callattr(o,"m",[1,2])', () => { sink = $j.callattr(o, 'm', [1, 2], undefined); });
bench('o.text direct', () => { sink = o.text; });
bench('$j.getattr(o,"text")', () => { sink = $j.getattr(o, 'text'); });
bench('{a,b} literal', () => { sink = { rejection: null, maxTokens: 5 }; });
bench('jshost.plain(dict_of(...)) ', () => { sink = jh.plain($j.dict_of([['rejection', jh.NULL], ['maxTokens', 5]])); });
bench('$j.plain(dict_of(...))', () => { sink = $j.plain($j.dict_of([['rejection', jh.NULL], ['maxTokens', 5]])); });
// A Jac function JavaScript calls through its face, as a forwarder does.
function add(a, b) { return a + b; }
add.$p = ['a', 'b']; add.$face = ($r) => function (a, b) { return $r(this, arguments, new.target, [], undefined); }; $j.lengthed(add);
const face = $j.js_fn(add);
bench('add(1,2) direct', () => { sink = add(1, 2); });
bench('js_fn face add(1,2)', () => { sink = face(1, 2); });
// A nested def handed to JavaScript each call (as logRequest's write).
bench('closure handed to JS each call (titled/faced/named+js_fn)', () => { const w = $j.titled($j.faced($j.named(function () { return 1; }, [], 'x.<locals>.w'), add.$face), 'w'); sink = $j.plain(w); }, 2e5);
bench('generator wrapped by gen_fn each call', () => { sink = $j.any($j.gen_fn($j.faced($j.named(function* (it) { for (const x of it) yield x > 5; }, ['__it'], 'l'), add.$face))([1, 2, 3, 9])); }, 5e5);
bench('loop with early exit', () => { let r = false; for (const x of [1, 2, 3, 9]) if (x > 5) { r = true; break; } sink = r; });
bench('$j.truth(x)', () => { sink = $j.truth(o); });
bench('$j.tup(a,b)+unpack', () => { sink = $j.unpack($j.tup(1, 2), 2); });
bench('$j.cut(s,0,4000)', () => { sink = $j.cut('hello world', undefined, 4000, undefined); });
bench('$j.eq(a,"user")', () => { sink = $j.eq(o.text, 'user'); });
bench('$j.list(arr) + reversed cut', () => { sink = $j.cut($j.list([1, 2, 3]), undefined, undefined, -1); });
