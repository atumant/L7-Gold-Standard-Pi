#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%F_%H%M%S)"
BACKUP_DIR="$ROOT/savepoints/apply-backups/$STAMP"
mkdir -p "$BACKUP_DIR"

echo "== Apply scaffold =="
echo "Backup dir: $BACKUP_DIR"

if [ ! -f "$ROOT/rendered/nftables.conf" ]; then
  echo "Rendered nftables.conf not found. Run: ./bootstrap/install.sh render" >&2
  exit 1
fi

sudo cp /etc/nftables.conf "$BACKUP_DIR/nftables.conf.before" 2>/dev/null || true
sudo cp /etc/ssh/sshd_config "$BACKUP_DIR/sshd_config.before" 2>/dev/null || true
sudo cp -a /etc/ssh/sshd_config.d "$BACKUP_DIR/sshd_config.d.before" 2>/dev/null || true

echo "Staged actions (conservative scaffold):"
echo "- install rendered nftables.conf to /etc/nftables.conf"
echo "- reload nftables"
echo "- keep SSH changes manual/explicit until templating matures"

echo
ans="${AUTO_APPROVE:-}"
if [ -z "$ans" ]; then
  read -r -p "Apply rendered nftables.conf now? [y/N] " ans
fi
if [[ "$ans" =~ ^([Yy]|yes|YES|true|TRUE|1)$ ]]; then
  if sudo cmp -s "$ROOT/rendered/nftables.conf" /etc/nftables.conf 2>/dev/null; then
    echo "nftables config already matches rendered file; skipping copy."
  else
    sudo cp "$ROOT/rendered/nftables.conf" /etc/nftables.conf
    echo "Installed rendered nftables config."
  fi
  sudo nft -f /etc/nftables.conf
  sudo systemctl restart nftables
  echo "Applied nftables config."
else
  echo "Skipped apply."
fi

echo "Backups kept in: $BACKUP_DIR"
