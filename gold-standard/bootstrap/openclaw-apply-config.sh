#!/usr/bin/env bash
set -euo pipefail
PROFILE_FILE="${1:-}"
echo '== OpenClaw config/apply scaffold =='
if [ -n "$PROFILE_FILE" ]; then
  echo "Profile/config input: $PROFILE_FILE"
fi
cat <<'EOF'
Planned config/apply sequence:
1. verify openclaw binary exists
2. verify gateway service state
3. apply prepared config/profile inputs
4. run openclaw status / security audit
5. capture save point
EOF

command -v openclaw >/dev/null 2>&1 || {
  echo 'openclaw not installed or not in PATH' >&2
  exit 1
}
openclaw status --deep || true
