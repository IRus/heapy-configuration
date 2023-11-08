#!/bin/bash

set -e

git pull --verbose
cp --verbose .bash_aliases ~
cp --verbose docker-compose.yml ~/iot
../birdperson/update.sh
cd ~/iot || exit 1
docker compose up -d
