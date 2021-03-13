#!/bin/bash

set -e

if [ ! -f seq.txt ]; then
  echo "0" > seq.txt;
fi

SEQ="$(cat seq.txt)";
((SEQ = SEQ + 1));
echo "${SEQ}" > seq.txt;

docker build --build-arg VERSION="${SEQ}" -t "heapy/ttrss:latest" -t "heapy/ttrss:${SEQ}" .
docker build --build-arg VERSION="${SEQ}" -t "heapy/ttrss-nginx:latest" -t "heapy/ttrss-nginx:${SEQ}" --file Nginx.Dockerfile .
