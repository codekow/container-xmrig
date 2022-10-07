# XMRig Container

## Build

```
make
```

```
cd xmrig
podman build -t xmrig .
cd ..

cd xmrig-proxy
podman build -t xmrig-proxy .

```

## Usage docker / podman

single miner (allow optimization w/root)

```
# xmrig (standalone)
sudo podman run \
  --rm -it \
  --privileged \
  -u root \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='pool.supportxmr.com:3333' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='container' \
  xmrig

# meta-miner
sudo podman run \
  --rm -it \
  --privileged \
  -u root \
  -v $(pwd):/home/miner:z \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='gulf.moneroocean.stream:10016' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='container' \
  xmrig start_meta_miner

```

xmrig-proxy w/miner (root)

```
# start proxy
podman run \
  --rm -it \
  -p 3333:3333 \
  -e POOL_URL='pool.supportxmr.com:5555' \
  -e POOL_USER='4AwPZobe6PsLbfk5ntnv6Wa9DPL3aPd4N2b761EmsMpAQbBaJaAajQGhtBXDL9Mo4G649oAmWzNJU5L3YBS458iw2XkJp26' \
  -e POOL_PASS='proxy' \
  xmrig-proxy

# start xmrig
sudo podman run \
  --rm -it \
  --privileged \
  -u root \
  -e DONATE_LEVEL='1' \
  -e POOL_URL='10.88.0.1:3333' \
  -e POOL_USER='minion' \
  xmrig

```
