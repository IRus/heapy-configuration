#!/bin/bash

set -e

# Generic system update
apt update
apt list --upgradable
apt dist-upgrade -y
apt autoremove -y
apt autoclean
apt clean

# Install basic packages
apt install -y htop mc git nano

# Install Docker
# https://docs.docker.com/engine/install/debian/

# Install lazydocker
curl -SL https://github.com/jesseduffield/lazydocker/releases/download/v0.24.2/lazydocker_0.24.2_Linux_x86_64.tar.gz -o lazydocker.tar.gz
tar xzvf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/bin/lazydocker
rm lazydocker.tar.gz
