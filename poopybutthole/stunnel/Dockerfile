FROM alpine:latest
RUN apk --no-cache add stunnel
RUN mkdir -p /etc/stunnel /var/run/stunnel
COPY stunnel.conf /etc/stunnel/stunnel.conf
EXPOSE 443
ARG VERSION
RUN echo "Building ${VERSION}"
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
