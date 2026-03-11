#!/usr/bin/env bash
set -euo pipefail
eval "$($(dirname "$0")/platform-detect.sh)"

echo "== OpenClaw install/config phase =="
case "$PLATFORM" in
  debian-like)
    cat <<'EOF'
Planned Debian/Pi flow:
1. ensure Node 22+
2. install OpenClaw
3. run onboarding or apply prepared config
4. verify gateway status
EOF
    ;;
  macos)
    cat <<'EOF'
Planned macOS flow:
1. install OpenClaw or companion tooling
2. configure local profile
3. verify Control UI / gateway connection
EOF
    ;;
  windows)
    cat <<'EOF'
Planned Windows flow:
1. install supported OpenClaw runtime path
2. configure profile
3. verify UI/gateway connectivity
EOF
    ;;
  *)
    echo "Unsupported platform for OpenClaw install scaffold"
    ;;
esac
