#!/bin/sh
set -e

HOME=/home/miner

DEFAULT_DONATE_LEVEL='1'
DEFAULT_POOL_URL='gulf.moneroocean.stream:10128'
DEFAULT_POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26'
DEFAULT_POOL_PASS='space-heater'
#DEFAULT_EXTRA_ARGS='--tls --cpu-no-yield'
DEFAULT_EXTRA_ARGS=''

# copy default config
[ -e config.json ] || \
  cat /usr/local/bin/config.json > config.json

start_miner(){

# enable cuda
[ -e /usr/local/bin/libxmrig-cuda.so ] && \
  sed -i '/"cuda":/{n;s/"enabled":.*/"enabled": true,/}' config.json

# enable opencl
[ -d /dev/kfd ] && \
  sed -i '/"opencl":/{n;s/"enabled":.*/"enabled": true,/}' config.json

xmrig \
  --config=config.json \
  --donate-level "${DONATE_LEVEL:-$DEFAULT_DONATE_LEVEL}" \
  -o "${POOL_URL:-$DEFAULT_POOL_URL}" \
  -u "${POOL_USER:-$DEFAULT_POOL_USER}" \
  -p "${POOL_PASS:-$DEFAULT_POOL_PASS}" \
  --nicehash \
  --keepalive \
  ${EXTRA_ARGS:-$DEFAULT_EXTRA_ARGS}
}

start_meta_miner(){

# copy mm.config (config map)
[ -e /config/mm.json ] && cat /config/mm.json > mm.json

sed -i 's/"url": *"[^"]*",/"url": "localhost:3333",/' config.json
sed -i 's/"user": *"[^"]*",/"user": "'"${POOL_USER:-$DEFAULT_POOL_USER}"'",/' config.json

/usr/local/bin/mm.js \
  -p="${POOL_URL:-$DEFAULT_POOL_URL}" \
  -m="xmrig --config=config.json"

}

if [ "$1" != "" ]; then
  case "$1" in
    start_miner) "$@";;
    start_meta_miner) "$@";;
    *) exec "$@";;
  esac
else
  start_miner
fi
