#!/usr/bin/env bash
set -euo pipefail
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519_new}"
SSH_USER="${SSH_USER:-admin}"
SSH_HOST="${SSH_HOST:-10.77.0.1}"
LOCAL_PORT="${LOCAL_PORT:-18789}"
REMOTE_PORT="${REMOTE_PORT:-18789}"
exec ssh -i "$SSH_KEY" -N -L "${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT}" "${SSH_USER}@${SSH_HOST}"
