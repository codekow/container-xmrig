FROM  alpine:3

### https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL \
      org.opencontainers.image.description.vendor="xmrig" \
      org.opencontainers.image.description="A container used to mine XMR using xmrig" \
      org.opencontainers.image.source="https://github.com/codekow/container-xmrig"

# hadolint ignore=DL3018
RUN apk add --no-cache curl nodejs

# setup: xmrig
ENV XMRIG_VERSION="6.18.0"
ARG XMRIG_HASH="8de5a261b1a90db90c6de3a20041863520afa536b019b08e9fc781cb7ef1fcc1"
ARG XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz"

RUN curl -sL "${XMRIG_URL}" -o bin.tgz && \
    sha256sum < bin.tgz && \
    [ "$XMRIG_HASH  -" = "$(sha256sum < bin.tgz)" ] && \
    echo "XMRIG_HASH: PASSED" && \
    tar --strip-components=1 -C /usr/local/bin -zxf bin.tgz && \
    rm bin.tgz

# setup: meta-miner
ARG MM_URL="https://raw.githubusercontent.com/MoneroOcean/meta-miner/master/mm.js"

RUN curl -sL "${MM_URL}" -o /usr/local/bin/mm.js && \
    chmod +x /usr/local/bin/mm.js

# setup: entrypoint and other scripts over 
COPY bin /usr/local/bin

USER 1001

WORKDIR /home/miner
VOLUME /home/miner

EXPOSE 8080

ENV DONATE_LEVEL='1' \
    POOL_URL='pool.supportxmr.com:3333' \
    POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
    POOL_PASS='container'

ENTRYPOINT ["entrypoint.sh"]
