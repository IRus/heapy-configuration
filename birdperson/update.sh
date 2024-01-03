#!/bin/bash

set -e

sudo apt update
sudo apt list --upgradable
sudo apt upgrade
sudo apt autoremove
sudo apt autoclean
sudo apt clean

docker pull eclipse-mosquitto:2.0
docker pull koenkk/zigbee2mqtt:1.35.0
docker pull ghcr.io/home-assistant/home-assistant:stable

sudo cloudflared version
sudo cloudflared update
sudo cloudflared version
