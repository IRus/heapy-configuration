#!/bin/bash

set -e

sudo apt update
sudo apt list --upgradable
sudo apt upgrade
sudo apt autoclean
sudo apt clean

docker pull eclipse-mosquitto:2.0
docker pull koenkk/zigbee2mqtt:1.33.0
docker pull ghcr.io/home-assistant/home-assistant:stable
