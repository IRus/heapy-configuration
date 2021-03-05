FROM ubuntu:20.04 as base
WORKDIR /
RUN export DEBIAN_FRONTEND=noninteractive; apt-get update \
    && apt-get install --no-install-recommends -qqy \
        git \
        curl \
        build-essential \
        libssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/TelegramMessenger/MTProxy
WORKDIR /MTProxy

RUN make

RUN ls -l /MTProxy/objs/bin

