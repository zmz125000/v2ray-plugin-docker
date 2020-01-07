FROM golang:alpine as builder
RUN set -xe \
    && apk add --no-cache git \
    && go get -insecure github.com/shadowsocks/v2ray-plugin
FROM shadowsocks/shadowsocks-libev:edge
USER root
RUN set -xe \
    && apk add --no-cache ca-certificates
COPY --from=builder /go/bin/v2ray-plugin /usr/local/bin

ENV PLUGIN_OPTS="server" \
    PLUGIN="v2ray-plugin"

USER nobody

CMD exec ss-server \
    -s $SERVER_ADDR \
    -p $SERVER_PORT \
    -k ${PASSWORD:-$(hostname)} \
    -m $METHOD \
    -t $TIMEOUT \
    -d $DNS_ADDRS \
    -u \
    --plugin $PLUGIN \
    --plugin-opts $PLUGIN_OPTS \
    $ARGS
