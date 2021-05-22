#!/bin/bash

sudo systemctl stop nginx.service
# Uncomment to issue new certificate
# sudo letsencrypt certonly --standalone -d streetball.by
sudo certbot --standalone renew
sudo systemctl start nginx.service

# sudo certbot delete
# kotlin.link
# repo.kotlin.link
# bkug.by
# izotova.by
# heapy.io
# tgto.heapy.io
# kotbot.heapy.io
# comments.heapy.io
# ibragimov.by
# ruslan.ibragimov.by
# streetball.name
# streetball.by
# shop.streetball.name
