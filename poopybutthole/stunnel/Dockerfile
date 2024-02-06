FROM alpine:latest
RUN apk --no-cache add stunnel
RUN mkdir -p /etc/stunnel
COPY stunnel.pem /etc/stunnel/stunnel.pem
COPY stunnel.conf /etc/stunnel/stunnel.conf
RUN chown -R nobody:nobody /etc/stunnel
USER nobody
EXPOSE 443
ARG VERSION
RUN echo "Building ${VERSION}"
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
