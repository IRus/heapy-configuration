# poopybutthole

WireGuard VPN at `vpn.heapy.io:51820/udp`, managed by wg-easy v15.

## Root

Remove root password

```sh
passwd -d root
```

## Fix nat for wg

```sh
sudo nano /etc/systemd/system/load-iptable-nat.service
```

```ini
[Unit]
Description=Load iptable_nat module at boot

[Service]
Type=oneshot
ExecStart=/sbin/modprobe iptable_nat
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

```sh
sudo systemctl daemon-reload
sudo systemctl enable load-iptable-nat.service
```

## Run and update

```sh
cd /root/heapy-configuration/poopybutthole
docker compose pull wireguard
docker compose up -d wireguard
```

## Admin panel

With Tailscale connected, open <https://poopybutthole.tail872780.ts.net>.
Sign in with the wg-easy administrator account.

Configure the persistent HTTPS proxy on the server:

```sh
tailscale serve --bg --https=443 http://127.0.0.1:51821
```

The panel is available only within the tailnet. `INSECURE=true` permits the
local HTTP backend; Tailscale Serve provides HTTPS to clients.

## Data

`wireguard/data/wg-easy.db` stores VPN keys, client settings and administrator
accounts. The data directory is excluded from Git and must be preserved when
updating or recreating the container.
