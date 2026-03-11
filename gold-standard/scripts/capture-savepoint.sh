#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%F_%H%M%S)"
OUT="$ROOT/savepoints/$STAMP"
mkdir -p "$OUT"
printf 'timestamp=%s\n' "$(date --iso-8601=seconds)" > "$OUT/meta.txt"
sudo nft list ruleset > "$OUT/nftables.txt"
sudo sshd -T > "$OUT/sshd-T.txt"
sudo systemctl list-unit-files --type=service --state=enabled > "$OUT/enabled-services.txt"
sudo systemctl --no-pager --type=service --state=running > "$OUT/running-services.txt"
sudo ss -ltnup > "$OUT/listening-sockets.txt"
sudo wg show all > "$OUT/wireguard.txt" || true
printf '%s\n' "$OUT"
