ARG ROOT_IMAGE=debian
FROM ${ROOT_IMAGE:-debian} AS base

COPY ./assets /tmp/build
ADD ./micromamba /usr/local/bin/micromamba

RUN apt-get update && \
    xargs apt-get install -y --no-install-recommends < /tmp/build/base_packages && \
    bash /tmp/build/mamba-init.sh && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --set editor /usr/bin/vim.basic && ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

############################################
ARG BASE_IMAGE=base
FROM ${BASE_IMAGE:-base} AS public

COPY ./assets/ /tmp/build
COPY ./dotfiles /tmp/dotfiles

ARG _USER
ARG _UID
ARG _GID
ARG _HOME=/home/${_USER}
ARG _PW=rootpass

ENV TERM=xterm-256color

RUN usermod --password $(echo ${_PW} | openssl passwd -1 -stdin) root
RUN useradd -m ${_USER} -d ${_HOME} -u ${_UID} -s /bin/zsh && echo "${_USER}:${_PW}" | chpasswd
RUN su - ${_USER} -c /tmp/dotfiles/startup.sh
USER ${_UID}:${_GID}
WORKDIR ${_HOME}

############################################
ARG WORK_IMAGE=public
FROM ${WORK_IMAGE:-public} as worker
SHELL ["/bin/bash", "-c"]

ENV PYTHONPATH=.:${PYTHONPATH}
RUN echo rootpass | su - root -c "chmod g+w /opt/micromamba && chown :hugh /opt/micromamba && rm -r /tmp/build" && \
  source /etc/profile.d/mamba.sh && \
  micromamba install -y python=3.10
ENV PATH=$PATH:/opt/micromamba/bin
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --no-cache-dir \
    pip install flash-attn~=1.0 --no-build-isolation --no-cache-dir \
    pip cache purge
# flash-attn may take 20 mins for compilation
# flash-attn=1.0.9 usage: https://github.com/Dao-AILab/flash-attention/blob/main/usage.md (4dbcaa)

CMD ["/bin/zsh"]
