# Runbook

## Current live-state commands

### WireGuard
```bash
ip -brief address show wg0
sudo wg show wg0
sudo ss -lunp | grep 51820 || true
```

### Firewall
```bash
sudo nft list ruleset
```

### SSH
```bash
sudo sshd -T | egrep '^(listenaddress|passwordauthentication|pubkeyauthentication|x11forwarding|allowtcpforwarding|allowagentforwarding|allowstreamlocalforwarding)'
```

### OpenClaw UI from Mac
```bash
ssh -i ~/.ssh/id_ed25519_new -N -L 18789:127.0.0.1:18789 admin@10.77.0.1
```
Then browse to:
```text
http://127.0.0.1:18789/
```
If prompted for token, use the current gateway token from the host config.

## Recovery priorities
1. Local console
2. LAN SSH
3. WireGuard SSH
4. Pi Connect

## Rule
Never disable the current working path until the replacement path is proven.
