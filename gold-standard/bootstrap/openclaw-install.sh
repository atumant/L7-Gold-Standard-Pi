#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
eval "$($ROOT/bootstrap/platform-detect.sh)"
MODE="${1:-plan}"

echo "== OpenClaw install/config phase =="
echo "Platform: ${PLATFORM}"
echo "Mode: ${MODE}"

case "$PLATFORM" in
  debian-like)
    exec "$ROOT/bootstrap/openclaw-install-debian.sh" "$MODE"
    ;;
  macos)
    cat <<'EOF'
macOS path is not yet automated in this repo.
Current recommendation:
1. install OpenClaw locally
2. verify openclaw --version
3. apply profile/config manually or via a future managed script
4. verify gateway/UI connectivity
EOF
    ;;
  windows)
    cat <<'EOF'
Windows path is not yet automated in this repo.
Current recommendation:
1. install a supported OpenClaw runtime path
2. verify openclaw is callable
3. apply profile/config manually or via a future managed script
4. verify gateway/UI connectivity
EOF
    ;;
  *)
    echo "Unsupported platform: ${PLATFORM}" >&2
    exit 1
    ;;
esac
