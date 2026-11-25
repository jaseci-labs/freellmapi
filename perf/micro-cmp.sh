#!/bin/bash
# micro-cmp.sh <rounds>: micro.mts on the original, the Jac before this work and the Jac now, alternated; prints medians per case and whether the fingerprints match.
HERE=$(cd "$(dirname "$0")" && pwd); REPO=${REPO:-$(dirname "$HERE")}; ORIG=${ORIG:-}; BEFORE=${BEFORE:-}
export PATH=$(dirname "$(neojac node -p process.execPath)"):$PATH
T=$REPO/node_modules/.bin/tsx
O=$ORIG/server; B=$BEFORE/.jac/test/spaces/server/server; J=$REPO/.jac/test/spaces/server/server
rm -f /tmp/micro-*.jsonl
for i in $(seq $1); do
  for side in orig before jac; do d=$O; [ $side = jac ] && d=$J; [ $side = before ] && d=$B; $T $HERE/micro.mts $d 2>/dev/null | grep '^{"us"' >> /tmp/micro-$side.jsonl; done
done
node -e '
const fs=require("fs"); const rd=(f)=>fs.readFileSync(f,"utf8").trim().split("\n").map(JSON.parse);
const a=rd("/tmp/micro-orig.jsonl"), p=rd("/tmp/micro-before.jsonl"), b=rd("/tmp/micro-jac.jsonl");
const med=(x)=>{x=[...x].sort((p,q)=>p-q);return x[x.length>>1];};
console.log("| function | original µs/call | Jac before µs/call | Jac after µs/call | before/original | after/original |\n|---|---:|---:|---:|---:|---:|");
for (const k of Object.keys(a[0].us)) { const x=med(a.map(r=>r.us[k])), q=med(p.map(r=>r.us[k])), y=med(b.map(r=>r.us[k])); console.log(`| ${k} | ${x.toFixed(2)} | ${q.toFixed(2)} | ${y.toFixed(2)} | ${(q/x).toFixed(1)}x | ${(y/x).toFixed(1)}x |`); }
console.log("fingerprints", [...a,...p,...b].every(r=>r.fp===b[0].fp)?"identical":"DIFFER");'
echo "load: $(cat /proc/loadavg)"
