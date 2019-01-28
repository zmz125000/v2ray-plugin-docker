FROM golang:alpine as builder
RUN set -xe \
    && apk add --no-cache git \
    && go get github.com/shadowsocks/v2ray-plugin
FROM shadowsocks/shadowsocks-libev
USER root
RUN set -xe \
    && apk add --no-cache ca-certificates
COPY --from=builder /go/bin/v2ray-plugin /usr/local/bin
ENV PLUGIN_OPTS="server"
USER nobody
CMD exec ss-server \
    -s $SERVER_ADDR \
    -p $SERVER_PORT \
    -k ${PASSWORD:-$(hostname)} \
    -m $METHOD \
    -t $TIMEOUT \
    --fast-open \
    -d $DNS_ADDRS \
    -u \
    $PLUGIN_OPTS \
    $ARGS
