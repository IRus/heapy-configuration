# TODO

- Dockerize grafana
- Dockerize streetall.name
- Dockerize bkug.by
- Dockerize nginx (+certbot)
- Setup new instance using [Cloud-Init](https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup)
- Move workload to new instance
- Solution for offline metrics (loki + smth? [goaccess](https://www.cyberciti.biz/faq/how-to-install-goaccess-web-log-analyzer-with-nginx-on-linux-or-unix/)?)
- Tgto Postgres -> Xodus/Any embedded DB + Prom Metrics

# Instance modifications

1. Install base packages: `htop tmux mc`
2. Disable ssh password authentication
3. Set root password `passwd root`
4. Add ssh keys

## Docker install

## VPN/Outline Server

- How to use outline on macos/linux/windows?

## Docker-Compose

## Nginx

## Certbot

## Loki docker driver (postponed)

[Loki driver](https://grafana.com/docs/loki/latest/clients/docker-driver/) for docker:

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```
