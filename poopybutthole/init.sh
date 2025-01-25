#!/bin/bash

set -e

# Generic system update
dnf update -y

# Install basic packages
dnf install -y htop mc git nano

# Install Docker
# https://docs.docker.com/engine/install/fedora/
dnf -y install dnf-plugins-core
dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker
docker run hello-world
docker compose version

# Install lazydocker
curl -SL https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Linux_x86_64.tar.gz -o lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
