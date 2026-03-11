#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%F_%H%M%S)"
OUT="$ROOT/output/$STAMP"
mkdir -p "$OUT"

cat > "$OUT/manifest.env" <<EOF
RUN_ID=$STAMP
HOSTNAME=$(hostname)
DATE=$(date --iso-8601=seconds)
GIT_COMMIT=$(git -C "$ROOT/.." rev-parse --short HEAD 2>/dev/null || echo unknown)
PROFILE=${HOST_PROFILE:-unset}
LAN_SUBNET=${LAN_SUBNET:-unset}
WG_SUBNET=${WG_SUBNET:-unset}
WG_LISTEN_PORT=${WG_LISTEN_PORT:-unset}
EOF

echo "$OUT"
