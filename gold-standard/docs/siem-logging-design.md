# SIEM / Data Lake Logging Design

## Recommendation
Use **JSON Lines (jsonl)** as the primary event format and optionally mirror to **RFC 5424 syslog** for compatibility.

Why:
- easy for Splunk, Sentinel, Elastic, Chronicle, Loki, and generic pipelines
- easy for a human to inspect line-by-line
- easy to regex if needed
- supports nested correlation fields without inventing brittle delimiter formats

A simple `:` delimiter alone is not enough for long-term scale. It becomes ambiguous when messages contain colons, spaces, or nested attributes. Use JSONL as the canonical format and optionally emit logfmt/syslog mirrors for fallback parsing.

## Core event model
Every normalized event should include:
- `ts` — RFC3339 UTC timestamp
- `event_id` — unique event identifier
- `event_type` — stable taxonomy like `auth.ssh.login`
- `severity` — debug/info/warning/error/critical
- `host` — hostname, asset id, site, env
- `source` — subsystem, channel, file/service name
- `actor` — user/service identity when known
- `action` — what happened
- `outcome` — success/failure/unknown
- `network` — src/dst IPs, ports, peer data when known
- `trace` — run_id, session_id, correlation ids, git commit
- `message` — human-readable summary
- `raw` — bounded raw event copy when needed

## Correlation guidance
To support incident response and cross-tool correlation, carry:
- `run_id`
- `session_id`
- `parent_event_id`
- `host_boot_id`
- `git_commit`
- `customer_id`
- `asset_id`

## Suggested taxonomy examples
- `auth.ssh.login`
- `auth.ssh.failure`
- `vpn.wireguard.handshake`
- `fw.nftables.apply`
- `cfg.ssh.apply`
- `svc.disable`
- `bootstrap.preflight`
- `bootstrap.apply`
- `bootstrap.rollback`
- `openclaw.gateway.status`
- `openclaw.tool.exec`
- `git.push`

## Storage/forwarding strategy
1. write locally to JSONL buffer
2. rotate/compress
3. forward to one or more SIEM targets
4. let the SIEM parse, enrich, and retain

## Best-practice note
For broad compatibility, prefer:
- canonical `jsonl`
- optional RFC5424 syslog mirror
- optional logfmt mirror only for human grep convenience

## Front-end implication
A future customer-facing UI should edit a profile file like `configs/logging/logging-profile.example.yaml`, not raw code.
