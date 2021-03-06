#!/bin/bash

set -e

cd /home/rick/heapy-configuration/home/docker/ttrss || exit 1
./build.sh
cd /home/rick/heapy-configuration/ || exit 1
docker-compose up -d
