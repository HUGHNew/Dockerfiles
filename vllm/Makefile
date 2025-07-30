SHELL=/bin/bash

USER:=$(shell whoami)
UID:=$(shell id -u)
GRP:=docker
GID:=$(shell grep ${GRP} /etc/group|awk -F: '{print $$3}')


VLLM_VER=0.10.0
ROOT_IMAGE=debian:bookworm-20250630-slim
BASE_IMAGE=debian:bookworm-base
PUBLIC_IMAGE=debian-vllm:${VLLM_VER}
PUBLIC_EXTRA_IMAGE=debian-vllm:${VLLM_VER}-fa
PRIVATE_IMAGE=${USER}/debian-vllm:${VLLM_VER}

# maybe UV is better
MAMBA=micromamba
MAMBA_URL=https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-linux-64
DOTFILES=dotfiles
DOT_URL=https://github.com/HUGHNew/dotfiles.git


build: ${MAMBA} ${DOTFILES} nvidia
	DOCKER_BUILDKIT=1 docker build --no-cache \
		--build-arg BASE_IMAGE=${BASE_IMAGE}
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_IMAGE} .


build_private: ${DOTFILES}
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pri \
		--build-arg PUB_IMAGE=${PUBLIC_EXTRA_IMAGE} \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_IMAGE} .

# not for standard pipeline
build_public_extra:
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pube \
		--build-arg BASE_IMAGE=${PUBLIC_IMAGE} \
		-t ${PUBLIC_EXTRA_IMAGE} .


build_public:
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pub \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--build-arg _GRP=${GRP} \
		--build-arg _GID=${GID} \
		--build-arg VLLM_VER=${VLLM_VER} \
		-t ${PUBLIC_IMAGE} .


build_base: ${MAMBA} nvidia
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.base \
		--build-arg ROOT_IMAGE=${ROOT_IMAGE} \
		-t ${BASE_IMAGE} .

merge_cfg:
	cat Dockerfile.base Dockerfile.pub Dockerfile.pri > Dockerfile


${MAMBA}:
	[ -e ${MAMBA} ] || curl ${MAMBA_URL} -o micromamba -fsSL --compressed

${DOTFILES}:
	[ -e ${DOTFILES} ] || git clone --depth 1 ${DOT_URL} ${DOTFILES}

nvidia:
	if ! cat /etc/docker/daemon.json | grep -q "nvidia"; then \
		bash config.sh; fi

update_host_cuda:
	if ! command -v nvcc >/dev/null 2>&1; then \
		bash update_host_cuda.sh; fi