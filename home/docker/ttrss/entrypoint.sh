#!/bin/sh -e

for d in cache lock feed-icons; do
  chmod 777 /ttrss/$d
  find /ttrss/$d -type f -exec chmod 666 {} \;
done

sudo -E -u ttrss /usr/sbin/php-fpm -F

