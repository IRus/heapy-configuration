FROM ubuntu:20.04

EXPOSE 9000/tcp

ENV HOST_UID=1000
ENV HOST_GID=1000

ENV TTRSS_DB_TYPE="pgsql"
ENV TTRSS_DB_HOST="ttrss_database"
ENV TTRSS_DB_USER="tinytinyrss"
ENV TTRSS_DB_NAME="tinytinyrss"
ENV TTRSS_DB_PASS="HPALUhAY28G4LWDf"
ENV TTRSS_DB_PORT="5432"
ENV TTRSS_MYSQL_CHARSET="UTF8"
ENV TTRSS_SELF_URL_PATH="https://ibragimov.by/reader/"
ENV TTRSS_SINGLE_USER_MODE=false
ENV TTRSS_SIMPLE_UPDATE_MODE=false
ENV TTRSS_PHP_EXECUTABLE="/usr/bin/php"
ENV TTRSS_SESSION_COOKIE_LIFETIME=31536000
ENV TTRSS_CHECK_FOR_UPDATES=true
ENV TTRSS_PLUGINS="auth_internal"
ENV TTRSS_LOG_DESTINATION="sql"

RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        php-fpm \
        php-pdo php-gd php-pgsql php-mbstring \
        php-intl php-xml php-curl  \
        php-dom php-fileinfo php-json php-iconv \
        php-posix php-zip \
        git postgresql-client sudo ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i.bak 's/^listen = 127.0.0.1:9000/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i.bak 's/\(memory_limit =\) 128M/\1 256M/' /etc/php/7.4/fpm/php.ini
RUN sed -i.bak 's/;clear_env = .*/clear_env = no/i' /etc/php/7.4/fpm/pool.d/www.conf

RUN git clone --depth=1 https://git.tt-rss.org/fox/tt-rss.git /ttrss

RUN addgroup --gid $HOST_GID ttrss
RUN adduser --disabled-login --home /ttrss --gid $HOST_GID --uid $HOST_UID ttrss

RUN chown -R $HOST_GID:$HOST_UID /ttrss

WORKDIR /ttrss

ADD entrypoint.sh /ttrss

CMD ["/ttrss/entrypoint.sh"]
