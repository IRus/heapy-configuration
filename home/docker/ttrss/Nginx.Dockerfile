FROM nginx:1.19.7

RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://git.tt-rss.org/fox/tt-rss.git /ttrss/reader

COPY nginx.conf /etc/nginx/conf.d/default.conf
