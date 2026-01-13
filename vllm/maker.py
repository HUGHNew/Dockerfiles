#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
from dataclasses import dataclass

MAKE_PREFIX = """SHELL=/bin/bash

MAMBA=micromamba
MAMBA_URL=https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-linux-64
DOTFILES=dotfiles
DOT_URL=https://github.com/HUGHNew/dotfiles.git
BUILDX_URL=https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64

USER:=$(shell whoami)
UID:=$(shell id -u)
GRP:=docker
GID:=$(shell grep ${GRP} /etc/group|awk -F: '{print $$3}')
"""


IMAGE_TEMPLATE = """
ROOT_IMAGE={root}
BASE_IMAGE={base}
PUBLIC_IMAGE={public}
PUBLIC_EXTRA_IMAGE={pub_extra}
PRIVATE_IMAGE={private}
"""


@dataclass
class Image:
    root: str
    base: str
    public: str
    pub_extra: str
    private: str

    @classmethod
    def from_args(cls, args):
        root_image = args.root
        extra_suffix = "-fa" if args.fa else ""
        os_name, tag = root_image.split(":")
        os_ver = tag.split("-")[0]
        return cls(
            root=root_image,
            base=f"{os_name}:{os_ver}-base",
            public=f"{os_name}-vllm:${{VLLM_VER}}",
            pub_extra=f"{os_name}-vllm:${{VLLM_VER}}{extra_suffix}",
            private=f"${{USER}}/{os_name}-vllm:${{VLLM_VER}}",
        )

    def __str__(self):
        image_str = IMAGE_TEMPLATE.format_map(self.__dict__)
        if self.public == self.pub_extra: # no extra
            build_str = "build_seq: build_base build_public build_private"
        else:
            build_str = "build_seq: build_base build_public build_public_extra build_private"
        return image_str + '\n' + build_str + '\n'


def get_args():
    parser = argparse.ArgumentParser(
        "vllMake", description="Makefile generator for vllm image"
    )
    parser.add_argument("rule", type=str, help="basic rule file")
    parser.add_argument("--vllm", type=str, default="0.11.0", help="vllm version")
    parser.add_argument("--py", type=str, default="3.12", help="python version")
    parser.add_argument(
        "--fa", type=str, default=None, help="flash_attn wheel [optional]"
    ) # flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
    parser.add_argument(
        "-r",
        "--root",
        type=str,
        default="debian:bookworm-20250630-slim",
        help="root image",
    )
    return parser.parse_args()


def apply_args(args) -> str:
    if args.fa:
        version = f"VLLM_VER={args.vllm}\nPY_VER={args.py}\nFA_WHL={args.fa}"
    else:
        version = f"VLLM_VER={args.vllm}\nPY_VER={args.py}"
    return f"{MAKE_PREFIX}\n{version}{Image.from_args(args)}"


def main():
    args = get_args()
    with open(args.rule) as f:
        rules = f.read()
    make_lines = apply_args(args) + rules
    with open("Makefile", "w") as f:
        f.write(make_lines)


if __name__ == "__main__":
    main()
