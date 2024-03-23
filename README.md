# XMRig Container - Mine / Benchmark in Docker / Podman / Kubernetes

The purpose of this repo is to have a way to test limits and burn in hardware. 

Have you configured your security policies and resource limits effectively to curb user abuse?

Managing resources in Kubernetes can be a challenge. This repo is intended to simulate heavy workloads in order to observe enforcement of configured limits and security controls / policies.

Whatever your goal... launch Xmrig in Podman, Docker, or Kubernetes.

## Xmrig

:warning: NOTICE

[Xmrig](https://xmrig.com) is an open-source project for mining [Monero](https://www.getmonero.org) (XMR) cryptocurrency. It allows you to mine for a pool and receive Monero.

Running the container(s) without parameters ~~helps contribute $$~~ [sends metrics](https://moneroocean.stream/) for this project.

## Getting Started

## Usage Docker / Podman

```
docker run -it --rm ghcr.io/codekow/xmrig
```

```
podman run -it --rm ghcr.io/codekow/xmrig
```

Run meta miner

```
# see xmrig/bin/entrypoint.sh for more info.
# this might get documented... :)
podman run -it --rm ghcr.io/codekow/xmrig start_meta_miner
```

Examples below will use `podman` but should work the same with `docker`

### Environment Variables

For those of you who ~~hope to get rich~~ [want to lose money](https://whattomine.com/coins/101-xmr-cryptonight?hr=2.0&p=1350.0&fee=1.0&cost=0.18&cost_currency=USD&hcost=0.0&span_br=&span_d=24&commit=Calculate) mining, use the following example to configure your container(s).

NOTE: This container does not run as `root` by default

```
export POOL_URL="Pool URL"
export POOL_USER="Public Monero address"
export POOL_PASS="Miner ID - optional for most pools"
export DONATE_LEVEL="Donation in percent, default: 1"
export EXTRA_ARGS="Other parameters to pass to xmrig"

podman run \
  -it --rm \
  --name miner \
  -e POOL_URL=$POOL_URL \
  -e POOL_USER=$POOL_USER \
  -e POOL_PASS=$POOL_PASS \
  -e DONATE_LEVEL=$DONATE_LEVEL \
  -e EXTRA_ARGS=$EXTRA_ARGS \
  ghcr.io/codekow/xmrig
```

## Run as `root`

Running processes as `root` comes with risks and rewards (like most things).

If you are trying to improve hash rates with [Model Specific Register](https://xmrig.com/docs/miner/randomx-optimization-guide/msr) (MSR), like [taking risks](https://xkcd.com/1252) or just simply have a history of making [bad choices](https://en.wikipedia.org/wiki/Hot_Pockets) then the following is for you.

NOTE: mounting `/lib/modules` read-only inside the container allows the container to be compatible with more systems, but this is usually not required.

```
sudo podman run \
  -it --rm \
  --privileged \
  -u root \
  -v /lib/modules:/lib/modules:ro \
  ghcr.io/codekow/xmrig
```

## Development

```
# run lint
make lint

# run build
make build
```

## Links

- [Xmrig](https://xmrig.com)
- [Monero](https://www.getmonero.org)
<!-- - [Nvidia documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/)
- [Nvidia - Podman using CDI](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html) -->
