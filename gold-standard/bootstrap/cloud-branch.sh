#!/usr/bin/env bash
set -euo pipefail
PROFILE="${HOST_PROFILE:-}"
echo '== Cloud branch scaffold =='
case "$PROFILE" in
  cloud-*|*cloud*)
    cat <<'EOF'
Cloud profile detected.
Recommended branch behavior:
- preserve SSH over public/private cloud path until WireGuard is proven
- model cloud firewall/security-group expectations separately from nftables
- skip Pi Connect assumptions
- prefer snapshot/rebuild strategy over SD imaging language
EOF
    ;;
  *)
    echo 'No cloud profile detected.'
    ;;
esac
