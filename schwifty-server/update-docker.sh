#!/bin/bash

set -e

WORKDIR="/home/pi"
REPODIR="${WORKDIR}/heapy-configuration"

echo "[0] Pull remote images"
docker pull ghcr.io/irus/blog:main
docker pull ghcr.io/heapy/heapy.io:main
docker pull ghcr.io/heapy/kotlin_jobs:main

echo "[1] Update containers"
cd "${REPODIR}/schwifty-server" || exit 1
docker compose up -d
