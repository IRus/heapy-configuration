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


## Bedroom planner

Public read-only app at <https://bedroom.heapyhop.com>; private repository `IRus/bedroom-planner`.
The `bedroom_planner` service uses `ghcr.io/irus/bedroom-planner:main` on the
`schwifty` network, listening on port 8080 with `/healthz`. The image has its
own healthcheck and includes all frontend dependencies; no volumes or host
ports are needed. Kodkod handles unhealthy-container restarts. Automatic image
updates are disabled until the updater has dedicated private-registry credentials.

The remotely managed `schwifty-server` Cloudflare Tunnel routes this hostname
to `http://bedroom_planner:8080`; DNS is a proxied tunnel CNAME. Cloudflare Access
is intentionally disabled: anyone can load the page and base room model.
Edits stay in browser localStorage and do not modify server files. Tunnel
settings are managed in Cloudflare, not in this repository.

Deploy only this service:

```sh
docker compose pull bedroom_planner
docker compose up -d --no-deps bedroom_planner
docker compose exec -T bedroom_planner wget -qO- http://127.0.0.1:8080/healthz
```

Pulling requires read access to the private GHCR package. For the initial
deployment an authenticated Docker client pulled through `ssh://schwifty`, using
a temporary local registry login; no registry token was stored on the server.
Layouts are stored in browser localStorage per origin. To move a layout from
the old localhost/ChatGPT Site, export JSON there and import it at the new URL.

## Trip planner

<https://trip.heapyhop.com>: Kotlin/Ktor backend and static frontend, with a
shared SQLite plan and the last 100 revisions. The source `IRus/november_2026`
and image `ghcr.io/irus/november_2026:main` are private. Build locally using
`npm run build`, `./kotlin test`, and `./kotlin package` before the Docker build.
The service runs as UID 1000, with a read-only root and persistent
`./trip/data:/data`. Create this directory owned by pi (1000:1000), mode 700.
Do not delete it on deployment. Include this directory in server backups;
copy a stopped database or use SQLite's online backup API, not just the live
main DB file (WAL may contain recent transactions). JSON export and retained
revisions are recovery aids, not an off-server backup.

Cloudflare Access continues to allow the owner email and Nastya Access group.
Ktor independently validates the Access JWT issuer, audience and signature.
The normal tunnel route to `http://trip_heapyhop_com:8080` requires Access JWTs.
A more specific `/calendar/*` Access app bypasses browser login only for the
calendar subscription path. Its tunnel ingress matches exactly
`^/calendar/[A-Za-z0-9_-]{43}\.ics$` before the protected site route and does
not require an Access JWT. The backend requires a random 256-bit revocable
subscription token here, stored only as a SHA-256 hash. No public listing,
mutation, API or static content is exposed by that route. Do not log feed URLs.
Each signed-in user creates/revokes their own read-only link inside the site.

Publish with a temporary authenticated local Docker client over
`ssh://schwifty`; do not store registry tokens on the server. Automatic image
updates remain disabled. Restart only `trip_heapyhop_com`:

```sh
docker compose up -d --no-deps trip_heapyhop_com
docker compose exec -T trip_heapyhop_com curl -fsS http://127.0.0.1:8080/healthz
```

Verify the API redirects unauthenticated external clients to Access; direct
origin API calls without a valid JWT return 401. Unknown calendar tokens must
return 404. For rollback, preserve the database and use the previous image;
the pre-backend static image is retained locally as `:before-backend`.

## Solo accounting

`solo.heapyhop.com` routes through the existing Cloudflare Tunnel to
`http://solo_accounting:8080`. No host port is published. The source is the
`server/` directory in private repository `IRus/solo-history-processor`;
the private image is `ghcr.io/irus/solo-history-processor`. The final image
contains one static Go binary and CA certificates, running as UID 1000.
Kotlin conversion tooling remains independent.

Configure the `SOLO_*` variables from `.env-template` in the server's untracked
`.env`. `SOLO_TELEGRAM_CHAT_ID` is the negative group ID. Every human member of
this group (including anonymous group administrators) can use accounting;
other chats and bots are ignored. Give the bot admin rights or disable group
privacy in BotFather. Telegram uses long polling, not a webhook. A pre-existing
webhook must be deliberately removed before startup. Run only one instance.

Create `solo/data` owned by 1000:1000, mode 700. Do not replace this directory
on deployment. It contains the SQLite database, WAL, audit journal and durable
reply queue. A new database starts at zero; after the bot is running send
`Purchase: EUR970.98` once to establish the starting amount. Restarts do not
reset it. Foreign currencies are converted to EUR through Frankfurter's public
API without another secret. Daily rates are persisted, and the original amount,
rate, rate date and result are audited. Pending conversions survive restart;
the displayed balance remains provisional until they finish. See the source
README for date selection, exact rounding and unsupported currencies.

Reply `/reprocess` to a missed user message: its original chat/message ID
prevents duplicate booking. Deleted messages and lost edit history cannot be
recovered this way. HTTP SMS intake starts independently of Telegram.

GitHub Actions in the source repository runs vet, race tests and vulnerability
checks, then publishes AMD64/ARM64 images to private GHCR. It tags each commit
and reports its digest. Pin `SOLO_IMAGE` to the resulting immutable digest.
Keep registry credentials in a temporary local Docker client configuration,
not on schwifty. Automatic image updates are disabled. Deploy only this service:

```sh
mkdir -p solo/data
chmod 700 solo/data
docker compose up -d --no-deps solo_accounting
docker compose exec -T solo_accounting /solo healthcheck
```

The iPhone posts `{id,text}` to `POST /v1/operations` with
`Authorization: Bearer <SOLO_INGEST_API_KEY>`. Persist an ID and text before
sending and reuse them on retries. Replace the old direct Telegram call;
the server now publishes SMS and accounting results. Different IDs are distinct
operations even when the text matches. This does not deduplicate two separate
Shortcut runs that generated different IDs.

`GET /healthz` is liveness. Docker healthcheck uses public `GET /readyz` for
polling failures, permanent reply failures, and delayed delivery. Kodkod handles
unhealthy containers and notifications. `/v1/status`,
`/v1/audit`, and `/v1/outbox` require `SOLO_ADMIN_API_KEY`. Do not put that key
on the phone. The source README describes pagination, cancellations and retry
operations. Neither keys nor message text are written to application logs.

For a consistent SQLite snapshot including WAL data:

```sh
docker compose exec -T solo_accounting /solo backup /data/solo-backup-20261016.db
docker compose exec -T solo_accounting /solo verify
```

Backup scheduling and off-host retention are managed by the owner. Use unique
filenames and test restore before relying on the backups. Copying only the live
main DB file is unsafe. Restore with the service stopped, preserving the old
DB/WAL/SHM elsewhere and without mixing old WAL files with the restored DB.
Preserve data on rollback. Currency support upgrades the SQLite schema from
v1 to v2. A v1 binary refuses a v2 database: returning to v1 requires the
pre-upgrade snapshot and reconciliation of subsequent operations. Telegram retains pending updates
for at most 24 hours; longer outages require reconciliation. Telegram replies
can duplicate after ambiguous network failures, but carry the same audit
record number and never book the operation twice.
