#!/bin/bash
# suite-json.sh <server-dir> <out.json>: the server's vitest suite as its package script runs it, with per-file JSON.
HERE=$(cd "$(dirname "$0")" && pwd); REPO=${REPO:-$(dirname "$HERE")}; ORIG=${ORIG:-}; BEFORE=${BEFORE:-}
cd $1; export PATH=$(dirname "$(neojac node -p process.execPath)"):$PATH
VITEST=$(ls -d $1/node_modules/.bin/vitest $1/../node_modules/.bin/vitest $REPO/node_modules/.bin/vitest 2>/dev/null | head -1)
s=$(date +%s%N); $VITEST run --pool=forks --fileParallelism=false --reporter=json --outputFile=$2 > /dev/null 2>&1; rc=$?; e=$(date +%s%N)
echo "$1 rc=$rc wall=$(( (e-s)/1000000 ))ms load=$(cut -d' ' -f1 /proc/loadavg)"
