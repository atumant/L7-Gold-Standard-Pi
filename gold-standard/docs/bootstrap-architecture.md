# Bootstrap Architecture

## End-state goal
A reproducible bootstrap repository that can be installed with a single entry command, while keeping the install itself understandable and auditable.

## Recommended pattern
Preferred user-facing entrypoint:
```bash
curl -fsSL <bootstrap-url> | bash
```

But the hosted script should only act as a thin launcher that:
1. downloads a pinned release or git ref
2. verifies environment/preconditions
3. runs auditable local scripts from the checked-out repo

A future setup wizard UI can sit on top of this flow, but should remain a thin orchestration layer over the same auditable bootstrap steps rather than becoming a separate install path.

## Why not cram everything into one remote shell line?
- harder to audit
- harder to pin versions
- harder to recover from failure
- harder to support multiple profiles

## Planned bootstrap phases
1. preflight (OS/version, privilege, network, package manager)
2. package install (wireguard, nftables, qrencode, optional tools)
3. profile/env input loading
4. render staged configs from profile
5. OpenClaw install/verification
6. WireGuard server bootstrap
7. SSH hardening bootstrap
8. firewall apply with preserve-access strategy
9. service minimization profile
10. verification suite
11. save-point capture

## Inputs the bootstrap should accept
- hostname/profile name
- primary management interface (`eth0` or `wlan0`)
- whether secondary LAN interfaces should be disabled or kept as backup-only
- DHCP reservation notes for each active NIC MAC address
- WireGuard public endpoint / DDNS
- WireGuard subnet
- admin public key(s)
- whether Pi Connect should be preserved
- whether CUPS/desktop extras should remain
- whether to install OpenClaw or just harden the host

## Networking guardrail
Bootstrap should detect and warn if both Ethernet and Wi-Fi are active on the same private LAN subnet during preflight.

Default behavior should be:
1. require a declared primary management interface
2. recommend DHCP reservation for that interface
3. disable or de-prioritize the secondary interface unless the operator explicitly selects a multi-homed profile
4. record the canonical management address in rendered output and savepoints
5. if the environment looks like a consumer router deployment, recommend DHCP reservation rather than host-static IPs

## Setup wizard requirements
If a UI wizard is added, it should collect and render at least:
- primary management interface
- backup interface policy (disabled, backup-only, fully active)
- NIC MAC addresses
- router/DHCP reservation status
- canonical management address
- whether any inbound ports are intentionally forwarded
- rollback path if the chosen interface plan fails

## GitHub strategy
Best practice:
- keep canonical repo in GitHub
- keep working clone in Mac project folder
- optionally keep an on-device clone on the Pi
- sync through git, not ad-hoc file copying

## Authentication strategy
Do not bake GitHub tokens into repo files.
Use:
- GitHub CLI auth on the Mac, or
- SSH deploy keys / personal SSH keys, or
- fine-grained PAT stored outside git
