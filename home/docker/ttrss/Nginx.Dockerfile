FROM nginx:1.19.7

RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG VERSION
RUN echo "Building ${VERSION}"
COPY reader /ttrss/reader

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf
