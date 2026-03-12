#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RENDERED="$ROOT/rendered"
OPENCLAW_DIR="$RENDERED/openclaw"
SSH_DIR="$RENDERED/ssh"
SERVICES_DIR="$RENDERED/services"

mkdir -p "$OPENCLAW_DIR" "$SSH_DIR" "$SERVICES_DIR"

OPENCLAW_GATEWAY_BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
OPENCLAW_GATEWAY_AUTH_MODE="${OPENCLAW_GATEWAY_AUTH_MODE:-password}"
OPENCLAW_GATEWAY_PASSWORD="${OPENCLAW_GATEWAY_PASSWORD:-change-me}"
OPENCLAW_CONFIG_PATH="$OPENCLAW_DIR/openclaw.json"

cat > "$OPENCLAW_CONFIG_PATH" <<EOF
{
  "gateway": {
    "bind": "${OPENCLAW_GATEWAY_BIND}",
    "port": ${OPENCLAW_GATEWAY_PORT},
    "auth": {
      "mode": "${OPENCLAW_GATEWAY_AUTH_MODE}",
      "password": "${OPENCLAW_GATEWAY_PASSWORD}"
    }
  }
}
EOF

python3 -m json.tool "$OPENCLAW_CONFIG_PATH" >/dev/null
"$ROOT/bootstrap/render-ssh.sh"

cat > "$SERVICES_DIR/service-profile.env" <<EOF
PRESERVE_PI_CONNECT=${PRESERVE_PI_CONNECT:-true}
DISABLE_CUPS=${DISABLE_CUPS:-true}
DISABLE_RPCBIND=${DISABLE_RPCBIND:-true}
DISABLE_AVAHI=${DISABLE_AVAHI:-true}
DISABLE_MODEMMANAGER=${DISABLE_MODEMMANAGER:-true}
EOF

echo '== Config staging complete =='
echo "OpenClaw config: $OPENCLAW_CONFIG_PATH"
echo "SSH snippets: $SSH_DIR"
echo "Service profile: $SERVICES_DIR/service-profile.env"
ls -l "$OPENCLAW_DIR" "$SSH_DIR" "$SERVICES_DIR"
