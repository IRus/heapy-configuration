FROM ubuntu:22.04

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

RUN { \
        echo '[global]'; \
        echo 'error_log = /proc/self/fd/2'; \
        echo; echo '; https://github.com/docker-library/php/pull/725#issuecomment-443540114'; echo 'log_limit = 8192'; \
        echo; \
        echo '[www]'; \
        echo '; if we send this to /proc/self/fd/1, it never appears'; \
        echo 'access.log = /proc/self/fd/2'; \
        echo; \
        echo 'clear_env = no'; \
        echo; \
        echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
        echo 'catch_workers_output = yes'; \
        echo 'decorate_workers_output = no'; \
    } | tee /etc/php/8.1/fpm/pool.d/docker.conf; \
    { \
        echo '[global]'; \
        echo 'daemonize = no'; \
        echo; \
        echo '[www]'; \
        echo 'listen = 9000'; \
        echo 'user = ttrss';  \
        echo 'group = ttrss'; \
    } | tee /etc/php/8.1/fpm/pool.d/zz-docker.conf

RUN sed -i.bak 's/\(memory_limit =\) 128M/\1 256M/' /etc/php/8.1/fpm/php.ini

RUN addgroup --gid $HOST_GID ttrss
RUN adduser --disabled-login --home /ttrss --gid $HOST_GID --uid $HOST_UID ttrss

ADD entrypoint.sh /

COPY reader /ttrss/reader
ARG VERSION
RUN echo "Building ${VERSION}"

RUN chown -R $HOST_GID:$HOST_UID /ttrss

CMD ["/entrypoint.sh"]
