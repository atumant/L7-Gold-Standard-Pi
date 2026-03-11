#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
Raspberry Pi backup/image scaffold

Recommended future modes:
1. config export only
2. rsync-style filesystem backup
3. block image creation when safe/offline
4. encrypted archive export

Current project intentionally keeps this as a scaffold until backup target/storage policy is defined.
EOF
