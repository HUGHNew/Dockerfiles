#!/bin/bash

BIN_FOLDER="${BIN_FOLDER:-/usr/local/bin}"
MAMBA_PREFIX="${MAMBA_PREFIX:-/opt/micromamba}"
MAMBARC="${MAMBA_PREFIX}/condarc"
# init system bash
cat <<EOF >> "/etc/profile.d/mamba.sh"
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE=$BIN_FOLDER/micromamba;
export MAMBA_ROOT_PREFIX=$MAMBA_PREFIX;
__mamba_setup="\$(\$MAMBA_EXE shell hook --shell bash --root-prefix "\$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ \$? -eq 0 ]; then
    eval "\$__mamba_setup"
fi
unset __mamba_setup
EOF

[[ -e $MAMBA_PREFIX ]] || mkdir -p $MAMBA_PREFIX

cat <<EOF > "${MAMBARC}"
auto_activate_base: true
show_channel_urls: true
auto_stack: 0
pip_interop_enabled: true
auto_update_conda: false
channels:
  - conda-forge
  - nodefaults
channel_priority: strict
EOF
chmod 666 "${MAMBARC}"
chmod +x $BIN_FOLDER/micromamba
micromamba install -r $MAMBA_PREFIX -y python=3.10

cat <<EOF > /etc/pip.conf
[global]
index-url = https://mirrors.bfsu.edu.cn/pypi/web/simple
EOF
