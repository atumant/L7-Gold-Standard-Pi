#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo '== Config staging =='
echo "nftables template: $ROOT/configs/nftables/nftables.conf"
echo "ssh hardening template: $ROOT/configs/ssh/60-hardening.conf"
echo "ssh password template: $ROOT/configs/ssh/50-cloud-init.conf.example"
echo "wireguard template: $ROOT/configs/wireguard/wg0.conf.example"
echo
echo 'This phase currently stages/document templates only.'
echo 'Future enhancement: render templates from env vars and apply them with backups + rollback.'
