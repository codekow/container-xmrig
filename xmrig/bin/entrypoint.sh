#!/bin/sh
set -e

HOME=/home/miner

DEFAULT_DONATE_LEVEL='1'
DEFAULT_POOL_URL='gulf.moneroocean.stream:10016'
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

start_meta_miner(){

# copy default config
cat /usr/local/bin/config.json > config.json

# copy mm.config (config map)
[ -e /config/mm.json ] && cat /config/config.json > mm.json

sed -i 's/"url": *"[^"]*",/"url": "localhost:3333",/' config.json
sed -i 's/"user": *"[^"]*",/"user": "'"${POOL_USER:-$DEFAULT_POOL_USER}"'",/' config.json

mm.js \
  -p=gulf.moneroocean.stream:10001 \
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
