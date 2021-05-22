#!/bin/bash

docker pull ghcr.io/irus/currency:main
docker pull ghcr.io/kotlinby/awesome-kotlin:main

docker-compose -f /home/rick/heapy-configuration/docker-compose.yml up -d
