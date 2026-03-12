#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-plan}"
OPENCLAW_NPM_SPEC="${OPENCLAW_NPM_SPEC:-openclaw@latest}"
REQUIRED_NODE_MAJOR="${REQUIRED_NODE_MAJOR:-22}"

have() {
  command -v "$1" >/dev/null 2>&1
}

node_major() {
  node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0
}

print_plan() {
  cat <<EOF
== OpenClaw Debian/Pi installer ==
Plan:
1. verify Node.js ${REQUIRED_NODE_MAJOR}+ and npm are present
2. install or upgrade ${OPENCLAW_NPM_SPEC}
3. verify openclaw binary/version
4. run read-only health checks:
   - openclaw status
   - openclaw update status
EOF
}

verify_runtime() {
  if ! have node; then
    echo 'Node.js is missing. Install Node.js 22+ first.' >&2
    exit 1
  fi
  if ! have npm; then
    echo 'npm is missing. Install npm first.' >&2
    exit 1
  fi
  local major
  major="$(node_major)"
  if [ "$major" -lt "$REQUIRED_NODE_MAJOR" ]; then
    echo "Node.js $(node --version) found, but ${REQUIRED_NODE_MAJOR}+ is required." >&2
    exit 1
  fi
}

install_openclaw() {
  echo "Installing ${OPENCLAW_NPM_SPEC} ..."
  npm install -g "$OPENCLAW_NPM_SPEC"
}

verify_openclaw() {
  if ! have openclaw; then
    echo 'openclaw binary not found after install.' >&2
    exit 1
  fi

  echo '== openclaw version =='
  openclaw --version || true
  echo '== openclaw status =='
  openclaw status || true
  echo '== openclaw update status =='
  openclaw update status || true
}

case "$MODE" in
  plan)
    print_plan
    if have node; then
      echo "Detected node: $(node --version)"
    else
      echo 'Detected node: missing'
    fi
    if have npm; then
      echo "Detected npm: $(npm --version)"
    else
      echo 'Detected npm: missing'
    fi
    if have openclaw; then
      echo "Detected openclaw: $(openclaw --version 2>/dev/null || echo installed)"
    else
      echo 'Detected openclaw: missing'
    fi
    ;;
  apply)
    verify_runtime
    install_openclaw
    verify_openclaw
    ;;
  verify)
    verify_runtime
    verify_openclaw
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    echo 'Usage: bootstrap/openclaw-install-debian.sh [plan|apply|verify]' >&2
    exit 1
    ;;
esac
