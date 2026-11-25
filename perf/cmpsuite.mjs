// cmpsuite.mjs <orig.json> <jac.json>: per-file vitest durations, largest Jac-minus-original first.
import fs from 'node:fs';
const load = (f) => { const j = JSON.parse(fs.readFileSync(f)); const m = {}; for (const t of j.testResults) m[t.name.replace(/.*\/src\//, 'src/')] = { d: t.endTime - t.startTime, ok: t.status, n: t.assertionResults.length, pass: t.assertionResults.filter((a) => a.status === 'passed').length }; return { m, j }; };
const a = load(process.argv[2]), b = load(process.argv[3]);
console.log(`orig: ${a.j.numPassedTests}/${a.j.numTotalTests} passed; jac: ${b.j.numPassedTests}/${b.j.numTotalTests} passed`);
const rows = Object.keys(a.m).filter((k) => b.m[k]).map((k) => [k, a.m[k].d, b.m[k].d]);
const sa = rows.reduce((s, r) => s + r[1], 0), sb = rows.reduce((s, r) => s + r[2], 0);
console.log(`sum of file durations: orig ${(sa / 1000).toFixed(1)}s jac ${(sb / 1000).toFixed(1)}s`);
rows.sort((x, y) => (y[2] - y[1]) - (x[2] - x[1]));
for (const r of rows.slice(0, Number(process.argv[4] ?? 25))) console.log(`${String(r[1]).padStart(7)} ${String(r[2]).padStart(7)} ${(r[2] - r[1] >= 0 ? '+' : '') + (r[2] - r[1])}ms ${r[0]}`);
console.log('... fastest-gaining:'); for (const r of rows.slice(-8)) console.log(`${String(r[1]).padStart(7)} ${String(r[2]).padStart(7)} ${r[2] - r[1]}ms ${r[0]}`);
