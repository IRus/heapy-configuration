FROM ubuntu:20.04

ARG HUGO_VERSION

RUN export DEBIAN_FRONTEND=noninteractive; apt update \
    && apt install --no-install-recommends -yq \
        asciidoctor \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.deb" \
    && dpkg -i "hugo_${HUGO_VERSION}_Linux-64bit.deb" \
    && rm "hugo_${HUGO_VERSION}_Linux-64bit.deb"

VOLUME /data
WORKDIR /data

EXPOSE 1313

ENTRYPOINT ["hugo"]
