# XMRig Container

The purpose of this repo is to have a way to test limits and burn in on hardware.

## Build

```
# run lint
make lint

# run build
make build
```

## Usage docker / podman

single miner (allow optimization w/root)

```
# xmrig (standalone)
sudo podman run \
  --rm -it \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -u root \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='pool.supportxmr.com:3333' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='container' \
  ghcr.io/codekow/xmrig

# meta-miner
sudo podman run \
  --rm -it \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -u root \
  -v $(pwd):/home/miner:z \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='gulf.moneroocean.stream:10016' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='container' \
  ghcr.io/codekow/xmrig start_meta_miner

```

xmrig-proxy w/miner (root)

```
# start proxy
podman run \
  --rm -it \
  --name xmrig-proxy \
  -p 3333:3333 \
  -e POOL_URL='pool.supportxmr.com:5555' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='proxy' \
  ghcr.io/codekow/xmrig-proxy

# start xmrig
sudo podman run \
  --rm -it \
  --privileged \
  -u root \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='xmrig-proxy:3333' \
  -e POOL_USER='minion' \
  ghcr.io/codekow/xmrig
```
