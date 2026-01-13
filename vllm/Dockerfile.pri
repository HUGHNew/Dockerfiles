ARG PUB_IMAGE=base
FROM ${PUB_IMAGE} AS public

ARG _USER
ARG _UID
ARG _GID
ARG _GRP
ARG _HOME=/home/${_USER}
ARG _PW=userpass

ENV TERM=xterm-256color
RUN if ! getent group ${_GID} > /dev/null 2>&1; then \
      groupadd -g ${_GID} ${_GRP}; fi && \
    useradd -m ${_USER} -d ${_HOME} -u ${_UID} -g ${_GID} -G users -s /bin/zsh && echo "${_USER}:${_PW}" | chpasswd
COPY ./dotfiles /tmp/dotfiles
RUN su - ${_USER} -c /tmp/dotfiles/startup.sh
USER ${_UID}:${_GID}
WORKDIR ${_HOME}

CMD ["/bin/zsh"]
