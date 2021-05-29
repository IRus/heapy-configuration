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
GIT_CHANGED=true
git pull origin master | grep -q -v "Already up-to-date." && GIT_CHANGED=false
cd - || exit 1

if $GIT_CHANGED; then
  docker build --progress=plain \
               --build-arg VERSION="${SEQ}" \
               -t "heapy/ttrss:latest" \
               -t "heapy/ttrss:${SEQ}" .
  docker build --progress=plain \
               --build-arg VERSION="${SEQ}" \
               -t "heapy/ttrss-nginx:latest" \
               -t "heapy/ttrss-nginx:${SEQ}" \
               --file Nginx.Dockerfile .
fi
