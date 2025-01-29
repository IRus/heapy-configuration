## Wireguard setup

To access OpenApi server need to setup Wireguard VPN.

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
