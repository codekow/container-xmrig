#!/bin/sh
set -e

HOME=/home/miner

DEFAULT_POOL_URL='gulf.moneroocean.stream:10128'
DEFAULT_POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26'
DEFAULT_POOL_PASS='proxy'
DEFAULT_MODE='nicehash'
DEFAULT_COIN='monero'
DEFAULT_EXTRA_ARGS=''

start_proxy(){
xmrig-proxy \
  -o ${POOL_URL:-$DEFAULT_POOL_URL} \
  -u ${POOL_USER:-$DEFAULT_POOL_USER} \
  -p ${POOL_PASS:-$DEFAULT_POOL_PASS} \
  --mode ${MODE:-$DEFAULT_MODE} \
  --coin ${ALGO:-$DEFAULT_COIN} \
  --keepalive \
  ${EXTRA_ARGS:-$DEFAULT_EXTRA_ARGS}
}

if [ "$1" != "" ]; then
  exec "$@"
else
  start_proxy
fi
