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

## Monitoring

Grafana configuration is provisioned from git:

- `grafana/provisioning/datasources/datasources.yml` configures Prometheus and Loki.
- `grafana/provisioning/dashboards/dashboards.yml` loads dashboards from `grafana/dashboards`.
- `prometheus/config/prometheus.yml` scrapes applications, Grafana, Loki, Promtail, node exporter, and cAdvisor.
- `promtail/config/config.yml` ships the systemd journal to Loki. `level` is the
  journal priority (for container logs that means `info` for stdout / `err` for
  stderr — the stream, not the app level). For container logs Promtail also
  parses the real level out of the message into `detected_level`, e.g. query
  true application warnings/errors with
  `{container=~".+", detected_level=~"(?i)warn.*|err.*|fatal|panic"}`.

Apply monitoring changes with:

```
docker compose up -d monitoring_node_exporter monitoring_cadvisor monitoring_prometheus monitoring_loki monitoring_promtail monitoring_grafana
```

`kotlin_link` is intentionally not scraped until the correct metrics endpoint is configured.

## File drop (ibragimov.by/files)

A public, read-only directory listing served by the `ibragimov.by` nginx ingress
at <https://ibragimov.by/files/>. There is no web upload and no auth — anyone with
the link can browse and download.

Add files by placing them on the host under `ibragimov_by/files/` — the dir is
bind-mounted read-only into the container. Contents are git-ignored.
