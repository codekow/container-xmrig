#!/bin/sh
# set -e

HOME=/home/miner

check_cpu(){
  if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ]; then
    RESULT=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
  else
    RESULT=$(awk '{print $1}' < /sys/fs/cgroup/cpu.max)
  fi

  CPU_COUNT="NA"
  [ "${RESULT}" -gt 100 ] && CPU_COUNT=$((RESULT / 100000))
  echo "CPU: $CPU_COUNT"
}

check_memory(){
  if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    RESULT=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
  else
    RESULT=$(cat /sys/fs/cgroup/memory.max)
  fi

  MEMORY_SIZE="NA"
  [ "${MEMORY_SIZE}" -gt 100 ] && MEMORY_SIZE=$((RESULT / 1024 / 1024))
  echo "MEM: $MEMORY_SIZE Mi"
}

create_access_token(){
  if [ -x "$(command -v uuidgen)" ]; then
    uuidgen
  else
    cat /proc/sys/kernel/random/uuid
  fi
}

init_miner_benchmark(){
  TIMEOUT=200

  xmrig \
    --config=config.json \
    --donate-level "${DONATE_LEVEL:-$DEFAULT_DONATE_LEVEL}" \
    -o "${POOL_URL:-$DEFAULT_POOL_URL}" \
    -u "${POOL_USER:-$DEFAULT_POOL_USER}" \
    -p "${POOL_PASS:-$DEFAULT_POOL_PASS}" &
    pid=$!

  (sleep "${TIMEOUT}"; kill $pid) &
  
  wait $pid
  sleep 2
}

start_miner(){

  main

  xmrig \
    --config=config.json \
    --donate-level "${DONATE_LEVEL:-$DEFAULT_DONATE_LEVEL}" \
    -o "${POOL_URL:-$DEFAULT_POOL_URL}" \
    -u "${POOL_USER:-$DEFAULT_POOL_USER}" \
    -p "${POOL_PASS:-$DEFAULT_POOL_PASS}" \
    --http-enabled \
    --http-port=8080 \
    --http-host=0.0.0.0 \
    --http-access-token="${ACCESS_TOKEN:-$DEFAULT_ACCESS_TOKEN}" \
    --nicehash \
    --keepalive \
    ${EXTRA_ARGS:-$DEFAULT_EXTRA_ARGS}
}

start_meta_miner(){

  main

  # copy mm.config (config map)
  [ -e /config/mm.json ] && cat /config/mm.json > mm.json

  sed -i 's/"url": *"[^"]*",/"url": "localhost:3333",/' config.json
  sed -i 's/"user": *"[^"]*",/"user": "'"${POOL_USER:-$DEFAULT_POOL_USER}"'",/' config.json

  /usr/local/bin/mm.js \
    -m="xmrig --config=config.json" \
    -u="${POOL_USER:-$DEFAULT_POOL_USER}" \
    -p="${POOL_URL:-$DEFAULT_POOL_URL}" \
    --pass="${POOL_PASS:-$DEFAULT_POOL_PASS}" \
    --watchdog=240 \
    --hashrate_watchdog=80
}

main(){

  check_cpu
  check_memory

  # print access token
  [ -z "${ACCESS_TOKEN}" ] && \
    echo "
      =================================================
      API TOKEN: \033[32m${DEFAULT_ACCESS_TOKEN}\033[0m

      \033[31m⚠ This will change when the container restarts ⚠\033[0m
      =================================================
    "

  # check if current dir is writeable
  [ -w "${PWD}" ] || \
    cd /tmp || return

  # copy config (config map)
  [ -e /config/config.json ] && \
    cat /config/config.json > config.json

  # copy default config
  [ -e config.json ] || \
    cat /usr/local/bin/config.json > config.json

  # enable cuda
  [ -e /usr/local/bin/libxmrig-cuda.so ] && \
    sed -i '/"cuda":/{n;s/"enabled":.*/"enabled": true,/}' config.json

  # enable opencl
  [ -d /dev/kfd ] && \
    sed -i '/"opencl":/{n;s/"enabled":.*/"enabled": true,/}' config.json

  # disable cpu
  [ -z "${EXTRA_ARGS}" ] && return 0
    echo "${EXTRA_ARGS}" | grep -q no-cpu && \
    sed -i '/"cpu":/{n;s/"enabled":.*/"enabled": false,/}' config.json
}

DEFAULT_DONATE_LEVEL='1'
DEFAULT_POOL_URL='gulf.moneroocean.stream:10128'
DEFAULT_POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26'
DEFAULT_POOL_PASS='space-heater'
DEFAULT_ACCESS_TOKEN=$(create_access_token)
# DEFAULT_EXTRA_ARGS='--tls --cpu-no-yield'
DEFAULT_EXTRA_ARGS=''

if [ "$1" != "" ]; then
  case "$1" in
    start_miner) "start_miner";;
    start_meta_miner) "start_meta_miner";;
    *) exec "$@";;
  esac
else
  start_miner
fi
