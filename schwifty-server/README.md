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

## Enable the memory cgroup

Raspberry Pi OS boots with `cgroup_disable=memory`, which the firmware adds on
its own — it is not written anywhere in `cmdline.txt`. Without the memory
cgroup, Docker silently ignores every memory limit (`docker info` says
`WARNING: No memory limit support`) and cAdvisor reports zero for all memory
metrics, so the memory panels in Grafana stay empty.

Append to the single line in `/boot/firmware/cmdline.txt` — the file must stay
one line, anything after a newline is ignored:

```
cgroup_enable=memory cgroup_memory=1
```

The firmware still passes `cgroup_disable=memory`, both end up on the kernel
command line and the later one wins. Reboot, then verify:

```
cat /sys/fs/cgroup/cgroup.controllers   # must list `memory` (this host is cgroup v2)
docker info | grep -i "memory limit"    # the warning must be gone
```

## Tailscale serve (kotlm in the tailnet)

`kotlm` is the only service published outside this host, and only inside the
tailnet — there is no funnel, so nothing is reachable from the public internet.
Clients on other machines use it, for example `visa-spain` on `claws`, which
sets `KOTLM_BASE_URL=https://schwifty-server.tail872780.ts.net`.

The chain is: tailnet HTTPS on :443 -> `127.0.0.1:8080` -> the `ports:` binding
of the `kotlm` service in `compose.yaml`. Drop that binding and every off-host
client stops working; services inside this compose file are unaffected, they
reach the proxy as `kotlm:8080`.

Tailscale keeps this config in `/var/lib/tailscale/tailscaled.state`, which is
not in git. On a new host, recreate it after the node has joined the tailnet:

```
sudo tailscale serve --bg --https=443 http://127.0.0.1:8080
```

Verify, and clear it if it ever needs rebuilding:

```
tailscale serve status                  # must show / proxy http://127.0.0.1:8080
tailscale serve status --json           # the full handler map
curl -s https://<node>.<tailnet>.ts.net/live   # must answer OK
sudo tailscale serve reset              # removes every handler on this node
```

## Monitoring

Grafana configuration is provisioned from git:

- `grafana/provisioning/datasources/datasources.yml` configures Prometheus and Loki.
- `grafana/provisioning/dashboards/dashboards.yml` loads dashboards from `grafana/dashboards`.
- `prometheus/config/prometheus.yml` scrapes applications, Grafana, Loki, Alloy, node exporter, and cAdvisor.
- `alloy/config/config.alloy` ships the systemd journal to Loki. `level` is the
  journal priority (for container logs that means `info` for stdout / `err` for
  stderr — the stream, not the app level). For container logs Alloy also
  parses the real level out of the message into `detected_level`, e.g. query
  true application warnings/errors with
  `{container=~".+", detected_level=~"(?i)warn.*|err.*|fatal|panic"}`.
  It replaced Promtail, which reached end-of-life in March 2026.
- `grafana/dashboards/kotlm.json` (folder Monitoring, uid `kotlm-proxy`) shows the
  kotlm proxy: requests and tokens per client, why requests were refused
  (`rate_limited` is the per-minute cap, `budget_exhausted` the daily token
  budget from `kotlm/secrets/clients.json`), upstream errors, and failures to
  persist the session state.

Apply monitoring changes with:

```
docker compose up -d monitoring_node_exporter monitoring_cadvisor monitoring_prometheus monitoring_loki monitoring_alloy monitoring_grafana
```

Check the Alloy config before restarting it:

```
docker compose run --rm --no-deps monitoring_alloy validate /etc/alloy/config.alloy
```

`kotlin_link` is intentionally not scraped until the correct metrics endpoint is configured.

## File drop (ibragimov.by/files)

A public, read-only directory listing served by the `ibragimov.by` nginx ingress
at <https://ibragimov.by/files/>. There is no web upload and no auth — anyone with
the link can browse and download.

Add files by placing them on the host under `ibragimov_by/files/` — the dir is
bind-mounted read-only into the container. Contents are git-ignored.
