
CUDA_KEYRING_VER=1.1-1_all
DISTRO=${1:-debian12}
function download_and_install_cuda {
  [ -e cuda-keyring_${CUDA_KEYRING_VER}.deb ] || wget https://developer.download.nvidia.com/compute/cuda/repos/$1/$(uname -m)/cuda-keyring_${CUDA_KEYRING_VER}.deb
  if [[ $UID -eq 0 ]]; then
    SUDO=
  else
    echo "Current user is not root, using sudo for installation"
    SUDO=sudo
  fi
  $SUDO dpkg -i cuda-keyring_${CUDA_KEYRING_VER}.deb
  $SUDO apt update && $SUDO apt install -y cuda-toolkit
}

download_and_install_cuda $DISTRO