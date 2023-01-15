#!/bin/bash

set -e

TIME=$(date "+%s")
BACKUP_NAME="birdperson-${TIME}.tar.gz"
BACKUP_PATH="/tmp/${BACKUP_NAME}"

echo "Backuping to ${BACKUP_PATH}"

cd /home/pi || exit 1
sudo tar -cvpzf "${BACKUP_PATH}" /home/pi
sudo chown pi:pi "${BACKUP_PATH}"

echo "Archive ${BACKUP_PATH} created"

rclone moveto "${BACKUP_PATH}" "r2:birdperson/${BACKUP_NAME}"

echo "Archive ${BACKUP_NAME} uploaded to R2"
