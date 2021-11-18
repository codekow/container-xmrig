#!/bin/sh
set -e

HOME=/home/miner

DEFAULT_DONATE_LEVEL='1'
DEFAULT_POOL_URL='pool.supportxmr.com:3333'
DEFAULT_POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26'
DEFAULT_POOL_PASS='container'
#DEFAULT_EXTRA_ARGS='--cpu-no-yield'
DEFAULT_EXTRA_ARGS=''

start_miner(){
xmrig \
  --donate-level ${DONATE_LEVEL:-$DEFAULT_DONATE_LEVEL} \
  -o ${POOL_URL:-$DEFAULT_POOL_URL} \
  -u ${POOL_USER:-$DEFAULT_POOL_USER} \
  -p ${POOL_PASS:-$DEFAULT_POOL_PASS} \
  --nicehash \
  --keepalive \
  ${EXTRA_ARGS:-$DEFAULT_EXTRA_ARGS}
}

if [ "$1" != "" ]; then
  exec "$@"
else
  start_miner
fi
