FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  netbase \
  build-essential \
  clang \
  cmake \
  curl \
  git \
  npm \
  git-lfs \
  libpq-dev \
  pkg-config \
  jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=latest
RUN npm install n -g && \
    n $NODE_VERSION && \
    apt-get purge -y npm

RUN npm install yarn -g

# installing the dependencies of opam (including opam itself for simplicity)
RUN apt-get update && apt-get install -y \
  opam \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

  # installing the latest version of opam
RUN bash -c "mkdir opam-tmp && cd opam-tmp && " \
  "sh <(curl -fsSL https://opam.ocaml.org/install.sh) --download-only && find . && " \
  "install opam-* /usr/local/bin/opam && " \
  "cd .. && rm -rf opam-tmp"

ARG OCAML_VERSION=5.1.1
ARG PACKAGE_INSTALL_SCRIPT_FILENAME=install_ocaml_5.1_packages.sh
RUN opam init --auto-setup --yes --bare --disable-sandboxing
RUN opam update
RUN opam switch create $OCAML_VERSION
COPY $PACKAGE_INSTALL_SCRIPT_FILENAME /tmp/install_packages.sh
RUN /tmp/install_packages.sh && rm /tmp/install_packages.sh

ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND_OLD
ENV OPAMROOT=/root/.opam
ENV OPAMROOTISOK=1

ENTRYPOINT ["/usr/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
