#!/bin/bash

set -e

git pull
cp docker-compose.yml ~/iot/
../birdperson/update.sh