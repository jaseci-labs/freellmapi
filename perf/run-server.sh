#!/bin/bash
# run-server.sh <server-dir> <port> <datadir>: start the FreeLLMAPI server under tsx on neojac's Node.
HERE=$(cd "$(dirname "$0")" && pwd); REPO=${REPO:-$(dirname "$HERE")}; ORIG=${ORIG:-}; BEFORE=${BEFORE:-}
set -e
NODE_DIR=$(dirname "$(neojac node -p process.execPath)")
SDIR=$1; PORT=$2; DATA=$3
TSX=$(cd "$SDIR" && cd .. && pwd)/node_modules/.bin/tsx
[ -x "$TSX" ] || TSX=$REPO/node_modules/.bin/tsx
mkdir -p "$DATA"
cd "$SDIR"
export PATH=$NODE_DIR:$PATH FREEAPI_DB_PATH=$DATA/db.sqlite FREEAPI_CONFIG_PATH=$HERE/config.json \
  PORT=$PORT HOST=127.0.0.1 FREEAPI_ENV_PATH=/nonexistent ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef \
  NODE_ENV=production CATALOG_SYNC_DISABLED=1 COOLDOWN_PROBE_DISABLED=1 BUILTIN_MODEL_DISCOVERY=off HEALTH_CHECK_INTERVAL_MS=86400000 CUSTOM_MODEL_SYNC_INTERVAL_MS=86400000 PROXY_RATE_LIMIT_RPM=0 ADMIN_RATE_LIMIT_RPM=0
exec "$TSX" src/index.ts
