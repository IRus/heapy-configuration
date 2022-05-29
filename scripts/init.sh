#!/bin/bash

set -e

WORKDIR="/mnt/volume_ams3_01"
REPODIR="${WORKDIR}/heapy-configuration"

cd "${WORKDIR}" || exit 1

# Generic system update
dnf update -y

# Install basic packages
dnf install -y htop mc git nano

# Install Docker
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
docker run hello-world

# Install Docker Compose
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.5.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version

# Download repo
git clone https://github.com/IRus/heapy-configuration.git

# Data folder init
mkdir -p "${REPODIR}/data/nginx/logs"
mkdir -p "${REPODIR}/data/nginx/config"

# .env init
cp "${REPODIR}/poopybutthole/.env-template" "${REPODIR}/poopybutthole/.env"

# Setup config files
cp "${REPODIR}/.gitconfig" "/root/.gitconfig"

# Generate DH parameters
dnf install -y openssl
openssl dhparam -out "${REPODIR}/data/nginx/config/dhparam.pem" 4096
