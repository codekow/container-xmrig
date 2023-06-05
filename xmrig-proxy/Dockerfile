FROM docker.io/library/alpine:3

### https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL \
      org.opencontainers.image.description.vendor="xmrig" \
      org.opencontainers.image.description="A container used to mine XMR using xmrig" \
      org.opencontainers.image.source="https://github.com/codekow/container-xmrig"

ENV \
    POOL_URL='pool.supportxmr.com:3333' \
    POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
    POOL_PASS='proxy'

# hadolint ignore=DL3018
RUN apk add --no-cache curl

# setup: xmrig-proxy
ENV XMRIG_PROXY_VERSION="6.19.2"
ARG XMRIG_PROXY_HASH="77917f4e1372c0d591ecc2fd17dfb875bd8c2a6f372426a5a578642d2ff82ed9"
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
