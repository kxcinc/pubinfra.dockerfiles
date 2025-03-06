## base image
ARG OS_VERSION=24.04
FROM ubuntu:$OS_VERSION

## prologue
ARG NODE_VERSION=latest
ARG OCAML_VERSION=5.1.1
ARG PACKAGE_INSTALL_SCRIPT_FILENAME=install_ocaml_5.1_packages.sh

WORKDIR /root

## apt dependencies
# NB: first line of dependencies is to match that of ocaml/opam:ubuntu-24.04-ocaml-5.3
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  build-essential curl git rsync sudo unzip nano libcap-dev libx11-dev bubblewrap \
  netbase \
  ca-certificates \
  build-essential \
  clang \
  cmake \
  curl \
  ssh \
  git \
  git-lfs \
  libpq-dev \
  pkg-config \
  jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="$PATH:/root/.bun/bin"

## node.js and yarn
RUN bun install -g n yarn && n install $NODE_VERSION

## latest version of opam
RUN bash -c "mkdir opam-tmp && cd opam-tmp && sh <(curl -fsSL https://opam.ocaml.org/install.sh) --download-only && find . && install opam-* /usr/local/bin/opam && cd .. && rm -rf opam-tmp"

## opam switch setup
RUN opam init --auto-setup --yes --bare --disable-sandboxing
RUN opam update
RUN opam switch create $OCAML_VERSION

ENV OPAMROOT=/root/.opam
ENV OPAMROOTISOK=1

## preferred opam packages
COPY $PACKAGE_INSTALL_SCRIPT_FILENAME /tmp/install_packages.sh
RUN /tmp/install_packages.sh && rm /tmp/install_packages.sh

## for backward compatibility
RUN ln -s /usr/local/bin/opam /usr/bin/opam

## epilogue
ENTRYPOINT ["/usr/local/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
