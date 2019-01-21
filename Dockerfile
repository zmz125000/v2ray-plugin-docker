FROM golang:alpine as builder
RUN set -xe \
    && apk add --no-cache git \
    && go get github.com/shadowsocks/v2ray-plugin \
    && go get github.com/FiloSottile/mkcert
FROM alpine
COPY --from=builder /go/bin/v2ray-plugin /usr/local/bin
COPY --from=builder /go/bin/mkcert /usr/local/bin
RUN set -xe \
    && mkcert -install
