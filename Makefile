# see https://github.com/mvanholsteijn/docker-makefile/blob/master/Makefile

CONTAINER_CMD=podman
CONTAINER_BUILD_CONTEXT=.
CONTAINER_FILE_PATH=Dockerfile

USER=codekow
REGISTRY=ghcr.io
VERSION=latest

SHELL=/bin/bash


.PHONY: build


build: lint pre-build xmrig-build xmrig-proxy-build post-build


lint: venv lint-yaml lint-spellcheck


pre-build:


post-build:


main-build:


xmrig-build:
	cd xmrig; \
	$(CONTAINER_CMD) build -t $(REGISTRY)/$(USER)/xmrig:$(VERSION) $(CONTAINER_BUILD_CONTEXT) -f $(CONTAINER_FILE_PATH).patch

xmrig-proxy-build:
	cd xmrig-proxy; \
	$(CONTAINER_CMD) build -t $(REGISTRY)/$(USER)/xmrig-proxy:$(VERSION) $(CONTAINER_BUILD_CONTEXT) -f $(CONTAINER_FILE_PATH)

push:
	$(CONTAINER_CMD) push $(REGISTRY)/$(USER)/xmrig:$(VERSION)
	$(CONTAINER_CMD) push $(REGISTRY)/$(USER)/xmrig-proxy:$(VERSION)

lint-yaml:
	 $(VENV)/yamllint -c .yamllint .

lint-spellcheck:
	$(VENV)/pyspelling -c .spellcheck.yaml

include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2022.07.20/Makefile.venv"
	echo "147b164f0cbbbe4a2740dcca6c9adb6e9d8d15b895be3998697aa6a821a277d8 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv
