#!/bin/bash

set -e

if [ ! -f seq.txt ]; then
  echo "0" > seq.txt;
fi

SEQ="$(cat seq.txt)";
((SEQ = SEQ + 1));
echo "${SEQ}" > seq.txt;

docker build --progress=plain \
             --build-arg VERSION="${SEQ}" \
             -t "heapy/tinyproxy:main" .
