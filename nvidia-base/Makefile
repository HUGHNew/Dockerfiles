SHELL=/bin/bash

USER:=$(shell whoami)
UID:=$(shell id -u)
GID:=$(shell id -g)

# rootfs from Debian artifact <https://github.com/debuerreotype/docker-debian-artifacts>
ROOTFS_URL=https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-amd64/bookworm/oci/blobs/rootfs.tar.gz
ROOTFS=rootfs.tar.gz
ROOT_IMAGE=${USER}/debian:bookworm

# The base image should have the nvidia driver and python installed
PY_VERSION=310
NV_DRIVER=535
MAMBA=micromamba
BASE_IMAGE=${USER}/debian:nv${NV_DRIVER}-mamba-py${PY_VERSION}

PROJECT=
# CUDA_VERSION=11.7
PUBLIC_IMAGE=${USER}/debian-${PROJECT}:root
DOTFILES=dotfiles
DOT_URL=https://github.com/HUGHNew/dotfiles.git

PRIVATE_IMAGE=${USER}/debian-${PROJECT}:user

build: ${ROOTFS} ${MAMBA} ${DOTFILES}
	DOCKER_BUILDKIT=1 docker build --no-cache \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_REGISTRY}/${PRIVATE_IMAGE} .


build_private:
	DOCKER_BUILDKIT=1 docker build --no-cache \
		--build-arg PUBLIC_IMAGE=${PUBLIC_IMAGE} \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_IMAGE} .

build_public: ${DOTFILES}
	DOCKER_BUILDKIT=1 docker build --no-cache --target public \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		-t ${PUBLIC_IMAGE} .


build_base: ${MAMBA}
	DOCKER_BUILDKIT=1 docker build --no-cache --target base \
		-t ${BASE_IMAGE} .

build_root: ${ROOTFS}
	DOCKER_BUILDKIT=1 docker build --no-cache --target root \
		-t ${ROOT_IMAGE} .


${ROOTFS}:
	curl -o ${ROOTFS} -L "${ROOTFS_URL}"

${MAMBA}:
	curl "https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-linux-64" \
		-o micromamba -fsSL --compressed

${DOTFILES}:
	git clone --depth 1 ${DOT_URL} ${DOTFILES}