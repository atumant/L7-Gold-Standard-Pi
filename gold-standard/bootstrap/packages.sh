#!/usr/bin/env bash
set -euo pipefail

echo '== Package plan =='
echo 'This scaffold intentionally does not auto-install packages blindly yet.'
echo 'Expected package set for Debian-based Pi hosts:'
echo '  - wireguard'
echo '  - wireguard-tools'
echo '  - nftables'
echo '  - qrencode'
echo
echo 'If you want auto-install behavior later, add a confirmed package phase here.'
