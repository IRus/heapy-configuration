FROM nginx:stable-alpine

RUN apk --no-cache add git ca-certificates

ARG VERSION
RUN echo "Building ${VERSION}"
COPY reader /ttrss/reader

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf
