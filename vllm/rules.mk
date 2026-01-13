
build: ${MAMBA} ${DOTFILES} nvidia buildx
	DOCKER_BUILDKIT=1 docker build --no-cache \
		--build-arg BASE_IMAGE=${BASE_IMAGE}
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _GRP=${GRP} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_IMAGE} .

build_private: ${DOTFILES} buildx
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pri \
		--build-arg PUB_IMAGE=${PUBLIC_EXTRA_IMAGE} \
		--build-arg _USER=${USER} \
		--build-arg _UID=${UID} \
		--build-arg _GID=${GID} \
		--build-arg _GRP=${GRP} \
		--build-arg _HOME=${HOME} \
		-t ${PRIVATE_IMAGE} .

# not for standard pipeline
build_public_extra: buildx
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pube \
		--build-arg BASE_IMAGE=${PUBLIC_IMAGE} \
		--build-arg FA_WHL=${FA_WHL} \
		-t ${PUBLIC_EXTRA_IMAGE} .


build_public: buildx
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.pub \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--build-arg _GRP=${GRP} \
		--build-arg _GID=${GID} \
		--build-arg VLLM_VER=${VLLM_VER} \
		--build-arg PY_VER=${PY_VER} \
		-t ${PUBLIC_IMAGE} .


build_base: ${MAMBA} nvidia buildx
	DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile.base \
		--build-arg ROOT_IMAGE=${ROOT_IMAGE} \
		-t ${BASE_IMAGE} .

merge_cfg:
	cat Dockerfile.base Dockerfile.pub Dockerfile.pri > Dockerfile


${MAMBA}:
	[ -e ${MAMBA} ] || curl ${MAMBA_URL} -o micromamba -fsSL --compressed

${DOTFILES}:
	[ -e ${DOTFILES} ] || git clone --depth 1 ${DOT_URL} ${DOTFILES}

buildx:
	docker buildx version >/dev/null 2>&1 || bash buildx.sh ${BUILDX_URL}

nvidia:
	if ! cat /etc/docker/daemon.json | grep -q "nvidia"; then \
		bash config.sh; fi

update_host_cuda:
	if ! command -v nvcc >/dev/null 2>&1; then \
		bash cuda.sh; fi