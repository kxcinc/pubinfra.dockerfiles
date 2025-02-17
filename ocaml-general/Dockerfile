FROM ubuntu:22.04

ENV DEBIAN_FRONTEND_OLD=$DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
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
  jq
RUN rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=latest
RUN npm install n -g
RUN n $NODE_VERSION
RUN apt-get purge -y npm

RUN npm install yarn -g

RUN apt-get update
RUN apt-get install -y opam

ARG OCAML_VERSION=5.0.0
ARG PACKAGE_INSTALL_SCRIPT_FILENAME=install_ocaml_4_packages.sh
RUN opam init --auto-setup --yes --bare --disable-sandboxing
RUN opam switch create $OCAML_VERSION
COPY $PACKAGE_INSTALL_SCRIPT_FILENAME /tmp/install_packages.sh
RUN /tmp/install_packages.sh && rm /tmp/install_packages.sh

ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND_OLD
ENV OPAMROOT=/root/.opam
ENV OPAMROOTISOK=1

ENTRYPOINT ["/usr/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
