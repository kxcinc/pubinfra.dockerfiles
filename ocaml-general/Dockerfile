FROM ubuntu:22.04

ENV DEBIAN_FRONTEND_OLD=$DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  clang \
  cmake \
  curl \
  git \
  nodejs \
  pkg-config \
  rsync \
  yarn \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
  opam \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=ocaml-general
RUN groupadd -r $USERNAME && useradd -r -m -g $USERNAME $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

RUN opam init --auto-setup --yes --disable-sandboxing

ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND_OLD

ENTRYPOINT ["/usr/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
