## Generate a self-signed certificate

```bash
openssl req -new -x509 -days 65536 -nodes \
    -out stunnel.pem \
    -keyout stunnel.pem \
    -subj "/CN=localhost"
```
