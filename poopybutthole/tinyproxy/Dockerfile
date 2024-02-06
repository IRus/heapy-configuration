FROM alpine:latest
RUN apk add --no-cache tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ARG VERSION
RUN echo "Building ${VERSION}"
CMD ["tinyproxy", "-d"]
