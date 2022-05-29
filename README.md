# TODO

- [ ] heapy/komodo
- [ ] heapy/t/me
- [ ] streetball.name
- [ ] shop.streetball.name
- [ ] bkug.by
- [ ] store.bkug.by
- [ ] Dockerize streetall.name
- [ ] Dockerize bkug.by
- [ ] Solution for offline metrics (loki + smth? [goaccess](https://www.cyberciti.biz/faq/how-to-install-goaccess-web-log-analyzer-with-nginx-on-linux-or-unix/)?)

## Loki docker driver

[Loki driver](https://grafana.com/docs/loki/latest/clients/docker-driver/)

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

    logging:
      driver: loki
      options:
        loki-url: "http://localhost:3100/loki/api/v1/push"
```
