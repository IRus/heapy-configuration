#!/bin/bash

### Setup proxy using socat for Plex

sudo apt install -y socat

sudo tee /etc/systemd/system/plex-proxy.service <<'EOF'
[Unit]
Description=Plex proxy via Tailscale
After=network.target tailscaled.service

[Service]
ExecStart=/usr/bin/socat TCP-LISTEN:32400,fork,reuseaddr TCP:100.70.142.127:32400
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/plex-discovery.service <<'EOF'
[Unit]
Description=Plex GDM discovery proxy via Tailscale
After=network.target tailscaled.service

[Service]
ExecStart=/usr/bin/socat UDP-LISTEN:32414,fork,reuseaddr UDP:kashyyyk:32414
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now plex-proxy
sudo systemctl enable --now plex-discovery

sudo systemctl status plex-proxy
sudo systemctl status plex-discovery
