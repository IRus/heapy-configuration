#!/bin/bash

set -e

echo "Pull remote images"
docker pull ghcr.io/irus/pirs:main
docker pull ghcr.io/irus/blog:main
docker pull ghcr.io/irus/currency:main
docker pull ghcr.io/heapy/kotlin_jobs:main
docker pull ghcr.io/kotlinby/awesome-kotlin:main

echo "Build new ttrss images"
cd /home/rick/heapy-configuration/home/docker/ttrss || exit 1
./build.sh

echo "Update containers"
cd /home/rick/heapy-configuration/ || exit 1
/usr/local/bin/docker-compose up -d

echo "Remove unused images"
docker system prune -f
