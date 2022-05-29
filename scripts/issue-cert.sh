#!/bin/bash

DOMAIN="kotlin.link"
WORKDIR="/mnt/volume_ams3_01"
REPODIR="${WORKDIR}/heapy-configuration"

docker stop ingress

docker run -it --rm --name certbot \
  -v "${REPODIR}/data/letsencrypt/etc:/etc/letsencrypt" \
  -v "${REPODIR}/data/letsencrypt/var:/var/lib/letsencrypt" \
  -p 80:80 \
  -p 443:443 \
  certbot/certbot certonly --standalone -d "${DOMAIN}"
#  certbot/certbot delete

docker start ingress
