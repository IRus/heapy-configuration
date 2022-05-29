#!/bin/bash

echo "Secret used: [${PROXY_SECRET}]"

/mtproto-proxy --help

EXTERNAL_IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"
if [[ -z "$EXTERNAL_IP" ]]; then
  echo "[F] Cannot determine external IP address."
  exit 3
else
  echo "[+] Using the detected external IP: ${EXTERNAL_IP}."
fi

INTERNAL_IP="$(ip -4 route get 8.8.8.8 | grep '^8\.8\.8\.8\s' | grep -Po 'src\s+\d+\.\d+\.\d+\.\d+' | awk '{print $2}')"
if [[ -z "$INTERNAL_IP" ]]; then
  echo "[F] Cannot determine internal IP address."
  exit 4
else
  echo "[+] Using the detected internal IP: ${INTERNAL_IP}."
fi

if [[ -z "$PROXY_TAG" ]]; then
  exec /mtproto-proxy -u nobody -p 8080 -H 8888 -S "${PROXY_SECRET}" --nat-info "$INTERNAL_IP:$EXTERNAL_IP" --aes-pwd proxy-secret proxy-multi.conf -M 1
else
  exec /mtproto-proxy -u nobody -p 8080 -H 8888 -S "${PROXY_SECRET}" -P "${PROXY_TAG}" --nat-info "$INTERNAL_IP:$EXTERNAL_IP" --aes-pwd proxy-secret proxy-multi.conf -M 1
fi
