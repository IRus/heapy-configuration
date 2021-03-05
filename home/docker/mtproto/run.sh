#!/bin/bash

echo "Secret used: [${PROXY_SECRET}]"

/mtproto-proxy --help

exec /mtproto-proxy -u nobody -p 8080 -H 8888 -S "${PROXY_SECRET}" --aes-pwd proxy-secret proxy-multi.conf -M 1
