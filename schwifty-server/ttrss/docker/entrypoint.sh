#!/bin/bash

set -e

for d in cache lock feed-icons; do
  chmod 777 /ttrss/reader/$d
  find /ttrss/reader/$d -type f -exec chmod 666 {} \;
done

exec /usr/sbin/php-fpm7.4 -F
