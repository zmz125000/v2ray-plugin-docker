FROM golang:alpine as builder
RUN set -xe \
    && apk add --no-cache git \
    && go get github.com/shadowsocks/v2ray-plugin
FROM shadowsocks/shadowsocks-libev
USER root
RUN set -xe \
    && apk add --no-cache ca-certificates
COPY --from=builder /go/bin/v2ray-plugin /usr/local/bin
USER nobody
