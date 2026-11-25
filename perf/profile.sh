#!/bin/bash
# profile.sh <side> <server-dir> <n>: CPU-profile a server under n chat completions.
HERE=$(cd "$(dirname "$0")" && pwd); REPO=${REPO:-$(dirname "$HERE")}; ORIG=${ORIG:-}; BEFORE=${BEFORE:-}
side=$1; d=$2; n=$3
rm -rf /tmp/prof-$side; mkdir -p /tmp/prof-$side
NODE_OPTIONS="--cpu-prof --cpu-prof-dir=/tmp/prof-$side" setsid ./run-server.sh $d 4603 /tmp/prof-$side/data > /tmp/prof-$side.log 2>&1 < /dev/null &
pid=$!
until curl -sf localhost:4603/api/ping >/dev/null; do sleep 0.2; done
neojac node hammer.mjs 4603 /tmp/prof-$side/data/db.sqlite $n ${4:-chat}
kill -INT -- -$pid
for i in $(seq 50); do curl -sf localhost:4603/api/ping >/dev/null || break; sleep 0.2; done
sleep 3; ls -la /tmp/prof-$side
