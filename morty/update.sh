#!/bin/bash

set -e

cd ~/heapy-configuration/morty || exit 1
git pull --verbose
cp --verbose .bash_aliases ~
cp --verbose docker-compose.yml ~/iot
~/heapy-configuration/birdperson/update.sh
cd ~/iot || exit 1
docker compose up -d
