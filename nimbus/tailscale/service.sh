#!/bin/bash

### Setup proxy using socat for Plex

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

sudo systemctl enable --now plex-proxy
