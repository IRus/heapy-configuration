#!/bin/bash

set -e

WORKDIR="/mnt/volume_ams3_01"
REPODIR="${WORKDIR}/heapy-configuration"

# [0] Add update function to .bashrc
#
# function update() {
#   ~/mnt/volume_ams3_01/heapy-configuration/scripts/update.sh
# }
#
# function home() {
#   cd /mnt/volume_ams3_01/heapy-configuration/
# }

echo "[1] Update packages"
dnf update -y

echo "[2] Pull remote images"
docker pull ghcr.io/irus/blog:main
docker pull ghcr.io/irus/currency:main
docker pull ghcr.io/irus/open_pirs:main
docker pull ghcr.io/heapy/heapy.io:main
docker pull ghcr.io/heapy/kotlin_jobs:main
docker pull ghcr.io/kotlinby/awesome-kotlin:main

echo "[3] Build new ttrss images"
cd "${REPODIR}/home/docker/ttrss" || exit 1
./build.sh

echo "[4] Update containers"
cd "${REPODIR}/poopybutthole" || exit 1
docker compose up -d

echo "[5] Remove unused images"
docker system prune -f

echo "[6] Update certificates"

mkdir -p "${REPODIR}/data/letsencrypt/etc"
mkdir -p "${REPODIR}/data/letsencrypt/var"

# Generated
#  bkug.by
#  store.bkug.by
#  heapy.io
#  kotbot.heapy.io
#  vpn.heapy.io
#  ibragimov.by
#  ruslan.ibragimov.by
#  kotlin.link
#  repo.kotlin.link
#  shop.streetball.name
#  streetball.by
#  streetball.name
#  supolka.com

docker stop ingress

docker run -it --rm --name certbot \
  -v "${REPODIR}/data/letsencrypt/etc:/etc/letsencrypt" \
  -v "${REPODIR}/data/letsencrypt/var:/var/lib/letsencrypt" \
  -p 80:80 \
  -p 443:443 \
  certbot/certbot renew

docker start ingress
