## Root

Remove root password

```
passwd -d root
```

## Fix nat for wg

```
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

```
sudo systemctl daemon-reload
sudo systemctl enable load-iptable-nat.service
```
