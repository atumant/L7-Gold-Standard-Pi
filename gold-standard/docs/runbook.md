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

## LAN interface policy
Use one primary LAN management interface by default.

Rules:
- do not leave both Ethernet and Wi-Fi auto-connected on the same LAN unless multi-homing is intentional and documented
- reserve the primary interface address in DHCP
- if a secondary interface is kept, treat it as backup-only rather than the canonical management path
- when access becomes inconsistent after reboot/router churn, check for dual active DHCP leases first

Useful checks:
```bash
ip -br addr
ip route
nmcli device status
nmcli connection show
hostname -I
```

Router-side checks:
- verify Ethernet and Wi-Fi MAC addresses are distinct and correctly reserved
- verify any port forwards point to the Ethernet reserved IP, not a transient lease
- verify the LAN remains on an RFC1918 private subnet such as `192.168.x.x`

If wired should be primary and Wi-Fi should stop auto-connecting:
```bash
sudo nmcli connection modify netplan-wlan0-L7TechInc connection.autoconnect no
sudo nmcli device disconnect wlan0
```

Rollback:
```bash
sudo nmcli connection modify netplan-wlan0-L7TechInc connection.autoconnect yes
sudo nmcli connection up netplan-wlan0-L7TechInc
```

## Rule
Never disable the current working path until the replacement path is proven.
