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

## Why not cram everything into one remote shell line?
- harder to audit
- harder to pin versions
- harder to recover from failure
- harder to support multiple profiles

## Planned bootstrap phases
1. preflight (OS/version, privilege, network, package manager)
2. package install (wireguard, nftables, qrencode, optional tools)
3. OpenClaw install/verification
4. WireGuard server bootstrap
5. SSH hardening bootstrap
6. firewall apply with preserve-access strategy
7. service minimization profile
8. verification suite
9. save-point capture

## Inputs the bootstrap should accept
- hostname/profile name
- WireGuard public endpoint / DDNS
- WireGuard subnet
- admin public key(s)
- whether Pi Connect should be preserved
- whether CUPS/desktop extras should remain
- whether to install OpenClaw or just harden the host

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
