#!/bin/bash

# . ~/heapy-configuration/scripts/bash_include.sh
function update() {
  sudo apt-get update
  sudo apt-get dist-upgrade
  sudo apt-get autoremove
  sudo apt-get autoclean

  ~/heapy-configuration/scripts/ttrss-update.sh
  ~/heapy-configuration/scripts/certs-update.sh
}
