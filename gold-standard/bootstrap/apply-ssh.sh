#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/rendered/ssh"
STAMP="$(date +%F_%H%M%S)"
BACKUP_DIR="$ROOT/savepoints/apply-backups/$STAMP-ssh"
mkdir -p "$BACKUP_DIR"

[ -f "$SRC/50-cloud-init.conf" ] || { echo "Missing rendered SSH file: $SRC/50-cloud-init.conf" >&2; exit 1; }
[ -f "$SRC/60-hardening.conf" ] || { echo "Missing rendered SSH file: $SRC/60-hardening.conf" >&2; exit 1; }

sudo cp /etc/ssh/sshd_config "$BACKUP_DIR/sshd_config.before" 2>/dev/null || true
sudo cp -a /etc/ssh/sshd_config.d "$BACKUP_DIR/sshd_config.d.before" 2>/dev/null || true

echo "About to install rendered SSH config snippets:"
echo "- /etc/ssh/sshd_config.d/50-cloud-init.conf"
echo "- /etc/ssh/sshd_config.d/60-hardening.conf"
echo "Backups: $BACKUP_DIR"
ans="${AUTO_APPROVE:-}"
if [ -z "$ans" ]; then
  read -r -p "Apply rendered SSH snippets now? [y/N] " ans
fi
if [[ "$ans" =~ ^([Yy]|yes|YES|true|TRUE|1)$ ]]; then
  sudo cp "$SRC/50-cloud-init.conf" /etc/ssh/sshd_config.d/50-cloud-init.conf
  sudo cp "$SRC/60-hardening.conf" /etc/ssh/sshd_config.d/60-hardening.conf
  sudo sshd -t
  sudo systemctl reload ssh
  echo "Applied SSH snippets and reloaded sshd."
else
  echo "Skipped SSH apply."
fi
