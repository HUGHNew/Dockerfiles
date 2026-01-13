# Dockerfiles

Dockerfile for self usage

- alpine (cst)
- Python3-alpine (cst and UTSC source for apk | Aliyun source for pip)
- flask (cst and UTSC source)
- Torch-Flask(Base:flask)
  - Torchvision cpuonly
  - Flask==2.0.1 Flask-cors
- cs143 containers
- vllm: (debian12 + micromamba + dotfiles for vLLM):
  - run `python3 maker.py` to generate Makefile
  - run `python3 maker.py --fa _local_flash_attn_whl_` to generate Makefile with fa
  - 4 build stage:
    - *base* for os/PyPI mirror with micromamba
    - *public* for basic vllm env
    - *public_extra* for customization (e.g. flash_attn)
    - *private* for user usage (get rid of root)
