## Generate a self-signed certificate

```bash
openssl req -new -x509 -days 65536 -nodes \
    -out /etc/stunnel/stunnel.pem \
    -keyout /etc/stunnel/stunnel.pem \
    -subj "/CN=localhost"
```
