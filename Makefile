# see https://github.com/mvanholsteijn/docker-makefile/blob/master/Makefile

CONTAINER_CMD=podman
CONTAINER_BUILD_CONTEXT=.
CONTAINER_FILE_PATH=Dockerfile


USER=codekow
REGISTRY=ghcr.io


VERSION=latest

SHELL=/bin/bash


.PHONY: build


build: pre-build xmrig-build xmrig-proxy-build post-build


pre-build:


post-build:


main-build:


xmrig-build:
	cd xmrig; \
	$(CONTAINER_CMD) build -t $(REGISTRY)/$(USER)/xmrig:$(VERSION) $(CONTAINER_BUILD_CONTEXT) -f $(CONTAINER_FILE_PATH)

xmrig-proxy-build:
	cd xmrig-proxy; \
	$(CONTAINER_CMD) build -t $(REGISTRY)/$(USER)/xmrig-proxy:$(VERSION) $(CONTAINER_BUILD_CONTEXT) -f $(CONTAINER_FILE_PATH)

push:
	$(CONTAINER_CMD) push $(REGISTRY)/$(USER)/xmrig:$(VERSION)
	$(CONTAINER_CMD) push $(REGISTRY)/$(USER)/xmrig-proxy:$(VERSION)
	
