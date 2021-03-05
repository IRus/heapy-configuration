#!/bin/bash

set -e

cd /home/rick/nginx/files/ibragimov.by/root/reader/
git fetch
git diff origin/master
git pull
sudo chown www-data:www-data -R .
