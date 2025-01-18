SHELL=/bin/bash

USER:=$(shell whoami)
UID:=$(shell id -u)
GID:=$(shell id -g)


build: ${ROOTFS} ${MAMBA} ${DOTFILES}
	DOCKER_BUILDKIT=1 docker build --no-cache \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_REGISTRY}/${PRIVATE_IMAGE} .

build_public:
	DOCKER_BUILDKIT=1 docker build --target public \
		--build-arg ROOT_IMAGE=debian:stable-20240904-slim-ustc \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t nvidia:debian12 .
