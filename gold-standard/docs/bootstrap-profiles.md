# Bootstrap Profiles

## Purpose
A profile captures the inputs needed to reproduce a hardened host without hardcoding secrets into git.

## Recommended pattern
- commit `bootstrap/env.example`
- create a local, uncommitted env file per host
- feed that file into future render/apply phases

## Example host settings
- HOST_PROFILE=pi-openclaw
- WG_SUBNET=10.77.0.0/24
- WG_SERVER_ADDRESS=10.77.0.1/24
- WG_LISTEN_PORT=51820
- LAN_SUBNET=192.168.4.0/22
- SSH_USER=admin
- PRESERVE_PI_CONNECT=true

## Secrets rule
Do not commit:
- WireGuard private keys
- OpenClaw gateway tokens
- device-pairing state
- backup credentials

## Future direction
Later bootstrap phases should:
1. source a local env file
2. render templates into a staging directory
3. show a diff
4. apply with backup and rollback steps
5. capture a save point
