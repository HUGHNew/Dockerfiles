set -ex
BUILDX_URL=${1:-https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64}
mkdir -p ~/.docker/cli-plugins \
curl -SL ${BUILDX_URL} -o ~/.docker/cli-plugins/docker-buildx
chmod u+x ~/.docker/cli-plugins/docker-buildx