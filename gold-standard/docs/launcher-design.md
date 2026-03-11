# One-line Launcher Design

## Goal
Support a future operator-friendly bootstrap entrypoint like:
```bash
curl -fsSL https://example/bootstrap.sh | bash
```
without turning the actual system build into opaque shell soup.

## Design principle
The one-line launcher should be a thin fetcher, not the full installer.

## Recommended flow
1. Download a pinned repo release or archive
2. Verify basic integrity/version expectations
3. Unpack into a temporary working directory
4. Run `bootstrap/install.sh` with explicit phase(s)
5. Persist logs and save points to a user-chosen path

## Why this is safer
- auditable local scripts
- easier rollback and troubleshooting
- version pinning
- profile-driven installs
- cleaner separation between bootstrap transport and bootstrap logic

## Future launcher inputs
- profile URL or local env file
- hostname/profile name
- OpenClaw install toggle
- preserve-Pi-Connect toggle
- service minimization profile
- noninteractive vs guided mode

## Anti-pattern to avoid
Do not hide all logic in a giant curl-piped monolith that mutates SSH, firewall, and secrets without staged checkpoints.
