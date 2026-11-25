#!/bin/bash
# imp.sh <server-dir>: whole-process wall ms of importing the app graph under tsx, and the in-process import ms.
HERE=$(cd "$(dirname "$0")" && pwd); REPO=${REPO:-$(dirname "$HERE")}; ORIG=${ORIG:-}; BEFORE=${BEFORE:-}
cd $1; export PATH=$(dirname "$(neojac node -p process.execPath)"):$PATH ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef FREEAPI_ENV_PATH=/nonexistent
TSX=$REPO/node_modules/.bin/tsx
s=$(date +%s%N); i=$($TSX $HERE/imp.mts $1 2>/dev/null | tail -1); e=$(date +%s%N); echo "$(( (e-s)/1000000 ))/$i"
