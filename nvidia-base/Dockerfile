FROM scratch AS root
ADD rootfs.tar.gz /
COPY <<EOF /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: http://mirrors.ustc.edu.cn/debian
Suites: bookworm bookworm-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://mirrors.ustc.edu.cn/debian-security
Suites: bookworm-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

############################################
ARG ROOT_IMAGE=root
FROM ${ROOT_IMAGE:-root} AS base

COPY ./assets /tmp/build
ADD ./micromamba /usr/local/bin/micromamba

RUN apt update && \
    xargs apt-get install -y --no-install-recommends < /tmp/build/base_packages && \
    bash /tmp/build/mamba-init.sh && \
    rm -rf /var/lib/apt/lists/* /tmp/build

RUN update-alternatives --set editor /usr/bin/vim.basic && ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

############################################
ARG BASE_IMAGE=base
FROM ${BASE_IMAGE:-base} AS public

COPY ./assets/ /tmp/build
COPY ./dotfiles /tmp/dotfiles

ENV TERM=xterm-256color
ENV PYTHONPATH=.:${PYTHONPATH}
ENV PATH=$PATH:/opt/micromamba/bin
RUN bash /tmp/dotfiles/startup.sh

# TODO: Do your own public configuration here

############################################
ARG PUBLIC_IMAGE=public
FROM ${PUBLIC_IMAGE:-public} as private
ARG _USER
ARG _UID
ARG _GID
ARG _HOME=/sharefs/${_USER}
ARG _PW=rootpass

RUN usermod --password $(echo ${_PW} | openssl passwd -1 -stdin) root
RUN useradd -m ${_USER} -d ${_HOME} -u ${_UID} -s /bin/zsh && echo "${_USER}:${_PW}" | chpasswd
RUN su - ${_USER} -c /tmp/dotfiles/startup.sh
USER ${_UID}:${_GID}
WORKDIR ${_HOME}


CMD ["/bin/zsh"]
