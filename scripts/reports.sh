#!/bin/bash

sites=(
  "bkug.by"
  "heapy.io"
  "ibragimov.by"
  "ruslan.ibragimov.by"
  "izotova.by"
  "kotbot.heapy.io"
  "tgto.heapy.io"
  "repo.kotlin.link"
  "kotlin.link"
  "shop.streetball.name"
  "streetball.name"
  "supolka.com"
  "store.bkug.by"
)


tmp=$(mktemp)

for site in "${sites[@]}"; do
  echo "Processing ${site}"
  cat "/home/rick/nginx-logs/access-${site}.log" "/home/rick/nginx-logs/error-${site}.log" > "${tmp}"
  goaccess "${tmp}" -a -o "/home/rick/nginx/files/ibragimov.by/root/reports/${site}.html" --log-format=COMBINED
done

rm "${tmp}"
