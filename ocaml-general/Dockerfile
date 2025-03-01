ARG OS_VERSION=24.04

FROM ubuntu:$OS_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# NB: first line of dependencies is taken from ocaml/opam:ubuntu-24.04-ocaml-5.3
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential curl git rsync sudo unzip nano libcap-dev libx11-dev bubblewrap \
  netbase \
  ca-certificates \
  build-essential \
  clang \
  cmake \
  curl \
  git \
  git-lfs \
  libpq-dev \
  pkg-config \
  jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=latest
RUN curl -fsSL -o /usr/local/bin/n https://raw.githubusercontent.com/tj/n/master/bin/n && \
  chmod 0755 /usr/local/bin/n && \
  n $NODE_VERSION

RUN npm install yarn -g

# install the latest version of opam
RUN bash -c "mkdir opam-tmp && cd opam-tmp && sh <(curl -fsSL https://opam.ocaml.org/install.sh) --download-only && find . && install opam-* /usr/local/bin/opam && cd .. && rm -rf opam-tmp"

ARG OCAML_VERSION=5.1.1
ARG PACKAGE_INSTALL_SCRIPT_FILENAME=install_ocaml_5.1_packages.sh
RUN opam init --auto-setup --yes --bare --disable-sandboxing
RUN opam update
RUN opam switch create $OCAML_VERSION
COPY $PACKAGE_INSTALL_SCRIPT_FILENAME /tmp/install_packages.sh
RUN /tmp/install_packages.sh && rm /tmp/install_packages.sh

ENV DEBIAN_FRONTEND=
ENV OPAMROOT=/root/.opam
ENV OPAMROOTISOK=1

ENTRYPOINT ["/usr/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
