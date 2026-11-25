// prof2.mjs <cpuprofile>: inclusive time of each outermost Jac frame (function in .jac/), and core.js self time by function.
import fs from 'node:fs';
const p = JSON.parse(fs.readFileSync(process.argv[2]));
const dt = {}; for (let i = 0; i < p.samples.length; i++) dt[p.samples[i]] = (dt[p.samples[i]] ?? 0) + (p.timeDeltas[i] ?? 0);
const parent = new Map(); for (const n of p.nodes) for (const c of n.children ?? []) parent.set(c, n.id);
const byId = new Map(p.nodes.map((n) => [n.id, n]));
const isJac = (n) => /\/\.jac\/(server\/src|@jac)\//.test(n.callFrame.url);
const name = (n) => `${n.callFrame.functionName || '(anon)'} ${n.callFrame.url.replace(/.*\/\.jac\//, '')}`;
const outer = {}, coreSelf = {}, entry = {};
for (const n of p.nodes) {
  const t = dt[n.id] ?? 0; if (!t) continue;
  if (/@jac\/core\.js/.test(n.callFrame.url)) coreSelf[n.callFrame.functionName] = (coreSelf[n.callFrame.functionName] ?? 0) + t;
  // walk to root, remember outermost jac frame and the non-jac caller above it
  let cur = n.id, top = null, caller = null;
  while (cur !== undefined) { const m = byId.get(cur); if (isJac(m)) { top = m; caller = byId.get(parent.get(cur)); } cur = parent.get(cur); }
  if (top) { const k = name(top); outer[k] = (outer[k] ?? 0) + t; const ck = `${k} <- ${caller ? caller.callFrame.functionName + ' ' + caller.callFrame.url.replace(/.*\/(src\/)/, '$1') + ':' + caller.callFrame.lineNumber : '?'}`; entry[ck] = (entry[ck] ?? 0) + t; }
}
const top = (o, n) => Object.entries(o).sort((a, b) => b[1] - a[1]).slice(0, n).map(([k, v]) => `${(v / 1000).toFixed(0).padStart(6)}ms ${k}`).join('\n');
console.log(`-- outermost Jac frames (inclusive)\n${top(outer, 25)}\n-- with caller\n${top(entry, 25)}\n-- core.js self\n${top(coreSelf, 30)}`);
