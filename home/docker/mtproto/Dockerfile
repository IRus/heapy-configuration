FROM ubuntu:20.04 as builder
WORKDIR /
RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        ca-certificates \
        git \
        curl \
        build-essential \
        libssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/TelegramMessenger/MTProxy
WORKDIR /MTProxy

RUN make

FROM ubuntu:20.04
WORKDIR /
RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /MTProxy/objs/bin/mtproto-proxy .
ARG VERSION
RUN echo "Building ${VERSION}"
RUN curl -s https://core.telegram.org/getProxySecret -o proxy-secret
RUN curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

ENTRYPOINT /mtproto-proxy -u nobody -p 8888 -H 443 -S ${PROXY_SECRET} --aes-pwd proxy-secret proxy-multi.conf -M 1
