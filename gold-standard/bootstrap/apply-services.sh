#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROFILE="$ROOT/rendered/services/service-profile.env"
[ -f "$PROFILE" ] || { echo "Missing service profile: $PROFILE" >&2; exit 1; }
# shellcheck disable=SC1090
source "$PROFILE"

actions=()
[ "${DISABLE_CUPS:-false}" = "true" ] && actions+=("cups" "cups-browsed")
[ "${DISABLE_RPCBIND:-false}" = "true" ] && actions+=("rpcbind" "rpcbind.socket")
[ "${DISABLE_AVAHI:-false}" = "true" ] && actions+=("avahi-daemon" "avahi-daemon.socket")
[ "${DISABLE_MODEMMANAGER:-false}" = "true" ] && actions+=("ModemManager")

echo "Service actions to apply: ${actions[*]:-(none)}"
[ "${PRESERVE_PI_CONNECT:-true}" = "true" ] && echo "Pi Connect preserved."
ans="${AUTO_APPROVE:-}"
if [ -z "$ans" ]; then
  read -r -p "Apply service minimization now? [y/N] " ans
fi
if [[ "$ans" =~ ^([Yy]|yes|YES|true|TRUE|1)$ ]]; then
  for svc in "${actions[@]}"; do
    sudo systemctl stop "$svc" 2>/dev/null || true
    sudo systemctl disable "$svc" 2>/dev/null || true
    sudo systemctl mask "$svc" 2>/dev/null || true
  done
  echo "Applied service minimization."
else
  echo "Skipped service apply."
fi
