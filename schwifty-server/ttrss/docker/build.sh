#!/bin/bash

set -e

if [ ! -f seq.txt ]; then
  echo "0" > seq.txt;
fi

SEQ="$(cat seq.txt)";
((SEQ = SEQ + 1));
echo "${SEQ}" > seq.txt;

if [ ! -d reader ]; then
  echo "Clone repo"
  git clone https://git.tt-rss.org/fox/tt-rss.git reader
fi

cd reader || exit 1
echo "Pull changes"
git pull origin master || exit 1
cd - || exit 1

docker build --progress=plain \
             --build-arg VERSION="${SEQ}" \
             -t "heapy/ttrss:main" .
docker build --progress=plain \
             --build-arg VERSION="${SEQ}" \
             -t "heapy/ttrss-nginx:main" \
             --file Nginx.Dockerfile .
