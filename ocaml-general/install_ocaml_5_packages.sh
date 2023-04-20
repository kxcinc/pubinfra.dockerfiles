#!/bin/sh

opam install --yes \
  dune.3.7.0 \
  merlin \
  odoc.2.2.0 \
  ppxlib.0.28.0 \
  ppx_deriving.5.2.1 \
  js_of_ocaml.4.1.0 js_of_ocaml-ppx.4.1.0 js_of_ocaml-lwt.4.1.0 \
  sexplib.v0.15.1 ppx_sexp_conv.v0.15.1 \
  yojson.2.0.2 ppx_yojson_conv.v0.15.1 \
  jsonm.1.0.1 \
  ezjsonm.1.3.0 \
  ppx_optcomp.v0.15.0 \
  brr.0.0.4 \
  prr.0.1.1 \
  zed.3.2.0 \
  tezt.3.0.0 \
  ppx_inline_test.v0.15.0 \
  alcotest.1.6.0 \
  qcheck.0.20 \
  qcheck-alcotest.0.20 \
  && opam clean -y --logs --repo-cache --download-cache --switch-cleanup
