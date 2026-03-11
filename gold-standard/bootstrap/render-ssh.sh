#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/rendered/ssh"
mkdir -p "$OUT"

PASSWORD_AUTH="${PASSWORD_AUTH:-no}"
ALLOW_AGENT_FORWARDING="${ALLOW_AGENT_FORWARDING:-no}"
ALLOW_TCP_FORWARDING="${ALLOW_TCP_FORWARDING:-yes}"
ALLOW_STREAMLOCAL_FORWARDING="${ALLOW_STREAMLOCAL_FORWARDING:-yes}"
X11_FORWARDING="${X11_FORWARDING:-no}"

cat > "$OUT/50-cloud-init.conf" <<EOF
PasswordAuthentication ${PASSWORD_AUTH}
EOF

cat > "$OUT/60-hardening.conf" <<EOF
AllowAgentForwarding ${ALLOW_AGENT_FORWARDING}
AllowTcpForwarding ${ALLOW_TCP_FORWARDING}
AllowStreamLocalForwarding ${ALLOW_STREAMLOCAL_FORWARDING}
X11Forwarding ${X11_FORWARDING}
EOF

echo "Rendered SSH config to: $OUT"
ls -l "$OUT"
