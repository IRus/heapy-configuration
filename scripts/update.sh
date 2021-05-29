#!/bin/bash

set -e

docker pull ghcr.io/irus/currency:main
docker pull ghcr.io/kotlinby/awesome-kotlin:main

cd /home/rick/heapy-configuration/ || exit 1
docker-compose up -d
