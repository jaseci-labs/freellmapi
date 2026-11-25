// prof.mjs <cpuprofile> [filter]: top self time by function, and self time by file.
import fs from 'node:fs';
const p = JSON.parse(fs.readFileSync(process.argv[2]));
const dt = {}; const byId = new Map(p.nodes.map((n) => [n.id, n]));
for (let i = 0; i < p.samples.length; i++) dt[p.samples[i]] = (dt[p.samples[i]] ?? 0) + (p.timeDeltas[i] ?? 0);
const total = Object.values(dt).reduce((a, b) => a + b, 0);
const fn = {}, file = {};
for (const n of p.nodes) {
  const t = dt[n.id] ?? 0; const cf = n.callFrame;
  const f = cf.url.replace(/.*\/(node_modules\/[^/]+|\.jac\/.*|src\/.*)$/, '$1');
  const k = `${cf.functionName || '(anon)'} ${f}:${cf.lineNumber}`;
  fn[k] = (fn[k] ?? 0) + t; file[f] = (file[f] ?? 0) + t;
}
const top = (o, n) => Object.entries(o).sort((a, b) => b[1] - a[1]).slice(0, n).map(([k, v]) => `${(v / 1000).toFixed(0).padStart(7)}ms ${(100 * v / total).toFixed(1).padStart(5)}% ${k}`).join('\n');
console.log(`total ${(total / 1000).toFixed(0)}ms\n-- by file\n${top(file, 25)}\n-- by function\n${top(fn, 40)}`);
