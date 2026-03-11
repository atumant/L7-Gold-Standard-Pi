#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/rendered/facts"
mkdir -p "$OUT"

OS_NAME="unknown"
OS_VERSION="unknown"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_NAME="${ID:-unknown}"
  OS_VERSION="${VERSION_ID:-unknown}"
fi

cat > "$OUT/host-facts.env" <<EOF
HOSTNAME=$(hostname)
KERNEL=$(uname -r)
ARCH=$(uname -m)
OS_NAME=${OS_NAME}
OS_VERSION=${OS_VERSION}
EOF

ip -brief address > "$OUT/ip-brief-address.txt" || true
ip route > "$OUT/ip-route.txt" || true
systemctl list-unit-files --type=service --state=enabled > "$OUT/enabled-services.txt" || true

echo "Rendered host facts to: $OUT"
ls -l "$OUT"
