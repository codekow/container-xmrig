FROM docker.io/library/alpine:3

### https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL \
      org.opencontainers.image.description.vendor="xmrig" \
      org.opencontainers.image.description="A container used to mine XMR using xmrig" \
      org.opencontainers.image.source="https://github.com/codekow/container-xmrig"

# hadolint ignore=DL3018
RUN apk add --no-cache curl nodejs

# setup: xmrig
ENV XMRIG_VERSION="6.22.2"
ARG XMRIG_HASH="aa866149d6234a1f00e344a702b719a0d6b4c40d3905d861ed536df1933a1d25"
ARG XMRIG_URL="https://github.com/MoneroOcean/xmrig/releases/download/v${XMRIG_VERSION}-mo1/xmrig-v${XMRIG_VERSION}-mo1-lin64-compat.tar.gz"

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

EXPOSE 3333 8080

ENTRYPOINT ["entrypoint.sh"]
