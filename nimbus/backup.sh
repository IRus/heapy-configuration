#!/bin/bash

set -e

function sentry_start() {
    curl -X POST \
        'https://sentry.io/api/0/organizations/heapy/monitors/75b54c8c-7ef2-4077-9f00-adccd33841b3/checkins/' \
        --header "Authorization: DSN ${SENTRY_DSN}" \
        --header 'Content-Type: application/json' \
        --data-raw '{"status": "in_progress"}'
}

function sentry_finish() {
    CHECKIN_ID=$1
    curl -X PUT \
        "https://sentry.io/api/0/organizations/heapy/monitors/75b54c8c-7ef2-4077-9f00-adccd33841b3/checkins/${CHECKIN_ID}/" \
        --header "Authorization: DSN ${SENTRY_DSN}" \
        --header 'Content-Type: application/json' \
        --data-raw '{"status": "ok"}'
}

echo "Starting script, send notification to sentry.io"
CHECKIN_ID=$(sentry_start | jq -r .id)
echo "CHECKIN_ID: ${CHECKIN_ID}"

TIME=$(date "+%s")
BACKUP_NAME="nimbus-${TIME}.tar.gz"
BACKUP_PATH="/tmp/${BACKUP_NAME}"

echo "Backuping to ${BACKUP_PATH}"

cd /home/pi || exit 1
sudo tar -cvpzf "${BACKUP_PATH}" /home/pi
sudo chown pi:pi "${BACKUP_PATH}"

echo "Archive ${BACKUP_PATH} created"

echo "Uploading ${BACKUP_NAME} to R2"
rclone moveto "${BACKUP_PATH}" "r2:nimbus/${BACKUP_NAME}"

echo "Notifying sentry.io that script finished"
sentry_finish $CHECKIN_ID
