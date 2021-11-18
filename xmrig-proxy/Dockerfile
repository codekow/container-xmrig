FROM  alpine:3

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="xmrig-proxy" \
      maintainer="koree@redhat.com" \
      vendor="xmrig" \
      summary="Container for xmrig-proxy" \
      description="A container used to proxy mining XMR using xmrig" \
      org.opencontainers.image.source="https://github.com/codekow/container-xmrig"

ENV \
    POOL_URL='pool.supportxmr.com:3333' \
    POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
    POOL_PASS='proxy'

RUN apk add --no-cache curl

# setup: xmrig-proxy
ENV XMRIG_PROXY_VERSION="6.15.1"
ARG XMRIG_PROXY_HASH="25a80db75398f81105bbeef7f2b008d0f4d0fd10f6345d0dbf91440b7211dbd4"
ARG XMRIG_PROXY_URL="https://github.com/xmrig/xmrig-proxy/releases/download/v${XMRIG_PROXY_VERSION}/xmrig-proxy-${XMRIG_PROXY_VERSION}-linux-static-x64.tar.gz"

RUN curl -sL "${XMRIG_PROXY_URL}" -o bin.tgz && \
    sha256sum < bin.tgz && \
    [ "$XMRIG_PROXY_HASH  -" = "$(sha256sum < bin.tgz)" ] && \
    echo "XMRIG_PROXY_HASH: PASSED" && \
    tar --strip-components=1 -C /usr/local/bin -zxf bin.tgz && \
    rm bin.tgz

# setup: entrypoint and other scripts over 
COPY bin /usr/local/bin

USER 1001

WORKDIR /home/miner
VOLUME /home/miner

EXPOSE 3333 8080

ENTRYPOINT ["entrypoint.sh"]
