#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-plan}"

echo '== OpenClaw Debian/Pi installer =='
echo 'Expected prerequisites:'
echo '- Node.js 22+'
echo '- git, curl'
echo
if [ "$MODE" = "apply" ]; then
  if ! command -v node >/dev/null 2>&1; then
    echo 'Node.js is missing. Install Node 22+ first.' >&2
    exit 1
  fi
  echo 'Planned apply sequence:'
  echo '1. npm install -g openclaw@latest'
  echo '2. verify openclaw version'
  echo '3. optionally run openclaw onboard or apply config'
  npm install -g openclaw@latest
  openclaw --version || true
else
  cat <<'EOF'
Plan-only mode.
Future apply path:
- install/verify OpenClaw
- run onboarding or config import
- verify gateway health/status
EOF
fi
