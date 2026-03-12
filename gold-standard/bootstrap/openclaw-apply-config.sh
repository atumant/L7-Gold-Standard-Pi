#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-plan}"
CONFIG_SOURCE="${2:-$ROOT/rendered/openclaw/openclaw.json}"
TARGET_CONFIG="${OPENCLAW_TARGET_CONFIG:-$HOME/.openclaw/openclaw.json}"
BACKUP_DIR="$ROOT/savepoints/apply-backups"
STAMP="$(date +%F_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/openclaw.json.$STAMP.before"

have() {
  command -v "$1" >/dev/null 2>&1
}

ensure_source() {
  [ -f "$CONFIG_SOURCE" ] || {
    echo "Missing OpenClaw config source: $CONFIG_SOURCE" >&2
    echo 'Run ./bootstrap/stage-configs.sh first, or pass a config file path.' >&2
    exit 1
  }
  python3 -m json.tool "$CONFIG_SOURCE" >/dev/null
}

print_plan() {
  cat <<EOF
== OpenClaw config/apply ==
Source: $CONFIG_SOURCE
Target: $TARGET_CONFIG
Plan:
1. verify openclaw exists
2. validate JSON config source
3. back up existing target config if present
4. merge rendered gateway/controlUi values into target config
5. restart gateway
6. verify with openclaw status and update status
EOF
}

merge_config() {
  mkdir -p "$(dirname "$TARGET_CONFIG")" "$BACKUP_DIR"
  if [ -f "$TARGET_CONFIG" ]; then
    cp "$TARGET_CONFIG" "$BACKUP_FILE"
    echo "Backed up existing config to: $BACKUP_FILE"
  fi

  python3 - "$CONFIG_SOURCE" "$TARGET_CONFIG" <<'PY'
import json, pathlib, sys
src_path = pathlib.Path(sys.argv[1])
tgt_path = pathlib.Path(sys.argv[2])
src = json.loads(src_path.read_text())
if tgt_path.exists():
    tgt = json.loads(tgt_path.read_text())
else:
    tgt = {}

def deep_merge(dst, src):
    for k, v in src.items():
        if isinstance(v, dict) and isinstance(dst.get(k), dict):
            deep_merge(dst[k], v)
        else:
            dst[k] = v
    return dst

for section in ('gateway',):
    if section in src:
        if section not in tgt or not isinstance(tgt.get(section), dict):
            tgt[section] = {}
        deep_merge(tgt[section], src[section])

tgt_path.write_text(json.dumps(tgt, indent=2) + '\n')
print(f'merged config into {tgt_path}')
PY

  chmod 600 "$TARGET_CONFIG" 2>/dev/null || true
}

restart_gateway() {
  if have openclaw; then
    openclaw gateway restart || true
  fi
}

verify_openclaw() {
  openclaw status || true
  openclaw update status || true
}

case "$MODE" in
  plan)
    ensure_source
    print_plan
    ;;
  apply)
    have openclaw || { echo 'openclaw not installed or not in PATH' >&2; exit 1; }
    ensure_source
    merge_config
    restart_gateway
    verify_openclaw
    ;;
  verify)
    have openclaw || { echo 'openclaw not installed or not in PATH' >&2; exit 1; }
    ensure_source
    verify_openclaw
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    echo 'Usage: bootstrap/openclaw-apply-config.sh [plan|apply|verify] [config-source]' >&2
    exit 1
    ;;
esac
