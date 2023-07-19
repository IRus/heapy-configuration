#!/bin/bash

set -e

WORKDIR="/mnt/volume_ams3_01"
REPODIR="${WORKDIR}/heapy-configuration"

echo "[0] Pull remote images"
docker pull ghcr.io/irus/blog:main
docker pull ghcr.io/irus/currency:main
docker pull ghcr.io/heapy/heapy.io:main
docker pull ghcr.io/heapy/kotlin_jobs:main
docker pull ghcr.io/kotlinby/awesome-kotlin:main

echo "[1] Update containers"
cd "${REPODIR}/poopybutthole" || exit 1
docker compose up -d
