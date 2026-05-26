## Wireguard setup

To access OpenAI server need to setup Wireguard VPN.

1. Install Wireguard `sudo apt install wireguard resolvconf`
2. Grab conf from vpn.heapy.io
3. Put in `/etc/wireguard/wg0.conf`
4. Reboot
5. Start `sudo wg-quick up wg0`
6. Check `sudo wg`
7. Enable `sudo systemctl enable wg-quick@wg0`

## Disable wi-fi and enable pcie gen 3:

```
sudo nano /boot/firmware/config.txt

[all]
dtoverlay=disable-wifi
dtparam=pciex1_gen=3
```

## File drop (ibragimov.by/files)

A public, read-only directory listing served by the `ibragimov.by` nginx ingress
at <https://ibragimov.by/files/>. There is no web upload and no auth — anyone with
the link can browse and download.

Add files by placing them on the host under `ibragimov_by/files/` — the dir is
bind-mounted read-only into the container. Contents are git-ignored.
