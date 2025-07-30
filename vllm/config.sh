function debian-src {
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
}


function debian-install {
  sudo apt-get update
  # sudo apt-get install -y nvidia-container-toolkit
  export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
  sudo apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}
}


function debian-conf {
  echo '{"registry-mirrors": ["https://dockerpull.cn", "https://dockerpull.pw"]}' | sudo tee /etc/docker/daemon.json
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
}

# NVIDIA toolkit installation: <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html>

debian-src && debian-install && debian-conf