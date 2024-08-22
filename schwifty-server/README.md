## Wireguard setup

To access OpenApi server need to setup Wireguard VPN.

1. Install Wireguard `sudo apt install wireguard resolvconf`
2. Grab conf from vpn.heapy.io
3. Put in `/etc/wireguard/wg0.conf`
4. Reboot
5. Start `sudo wg-quick up wg0`
6. Check `sudo wg`
7. Enable `sudo systemctl enable wg-quick@wg0`
