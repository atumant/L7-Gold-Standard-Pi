# Gold Standard Pi Admin Host

Reproducible hardening baseline for an always-on Raspberry Pi running OpenClaw with:
- WireGuard remote admin access
- SSH key-only administration
- nftables default-deny firewall
- OpenClaw Control UI via SSH tunnel
- service minimization
- save points and verification steps

## Goals
- Cheap/free to replicate
- Private by default
- Audit-friendly baseline and evidence capture
- Preserves break-glass local/LAN access while migrating

## Current baseline
This repository was derived from a live Raspberry Pi host hardened in stages.

## Layout
- `docs/architecture.md` — target design and trust boundaries
- `docs/runbook.md` — operator steps and recovery
- `docs/bootstrap-architecture.md` — one-line installer plan
- `configs/` — hardened config templates
- `bootstrap/` — install/hardening/verify entrypoints
- `scripts/` — helper utilities and save-point capture
- `savepoints/` — dated operator save points

## Important principle
Do not ship secrets in git. Bootstrap scripts should consume environment variables or prompt securely. Local-only operator copies can exist outside git.
