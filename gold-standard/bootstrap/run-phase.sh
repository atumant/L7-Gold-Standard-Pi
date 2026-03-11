#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${OUT_DIR:?OUT_DIR required}"
PHASE="${1:?phase name required}"
shift
LOG="$OUT_DIR/${PHASE}.log"
{
  echo "== phase: $PHASE =="
  echo "timestamp=$(date --iso-8601=seconds)"
  "$@"
} | tee "$LOG"
