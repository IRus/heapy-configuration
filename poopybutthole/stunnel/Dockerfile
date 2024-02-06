FROM alpine:latest
RUN apk --no-cache add stunnel
RUN mkdir -p /etc/stunnel \
    && chown -R nobody:nobody /etc/stunnel
COPY stunnel.pem /etc/stunnel/stunnel.pem
COPY stunnel.conf /etc/stunnel/stunnel.conf
USER nobody
EXPOSE 443
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
