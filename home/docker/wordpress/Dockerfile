FROM wordpress:6.3-php8.2-apache

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis