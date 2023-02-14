FROM ubuntu:22.04

ENV DEBIAN_FRONTEND_OLD=$DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  clang \
  cmake \
  curl \
  git \
  npm \
  git-lfs \
  pkg-config \
  && rm -rf /var/lib/apt/lists/*

RUN npm install n -g && \
    n latest && \
    apt-get purge -y npm

RUN npm install yarn -g

RUN apt-get update && apt-get install -y \
  opam

ARG VER=4.12.1
RUN opam init --auto-setup --yes --bare --disable-sandboxing
RUN opam switch create $VER
RUN opam install --yes \
  dune.3.4.0 \
  merlin \
  odoc.2.1.1 \
  ppxlib.0.26.0 \
  ppx_deriving.5.2.1 \
  js_of_ocaml.4.1.0 js_of_ocaml-ppx.4.1.0 js_of_ocaml-lwt.4.1.0\
  sexplib.v0.15.0 ppx_sexp_conv.v0.15.1 \
  yojson.1.7.0 ppx_yojson_conv.v0.15.0 \
  jsonm.1.0.1 \
  ppx_optcomp.v0.15.0 \
  brr.0.0.3 \
  prr.0.1.1 \
  zed.3.2.0 \
  tezt.3.0.0 \
  ppx_inline_test.v0.15.0 \
  alcotest.1.6.0 \
  qcheck.0.19.1 \
  qcheck-alcotest.0.19.1

ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND_OLD
ENV OPAMROOT=/root/.opam
ENV OPAMROOTISOK=1

ENTRYPOINT ["/usr/bin/opam", "exec", "--"]
CMD ["/usr/bin/bash"]
