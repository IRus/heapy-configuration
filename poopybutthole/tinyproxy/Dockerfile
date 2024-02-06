FROM alpine:latest
RUN apk add --no-cache tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
ARG VERSION
RUN echo "Building ${VERSION}"
CMD ["tinyproxy", "-d"]
