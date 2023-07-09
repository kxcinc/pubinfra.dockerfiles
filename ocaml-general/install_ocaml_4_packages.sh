#!/bin/sh

opam install --yes \
  dune.3.9.1 \
  merlin \
  odoc.2.2.0 \
  ppxlib.0.26.0 \
  bisect_ppx.2.8.2 \
  ppx_deriving.5.2.1 \
  js_of_ocaml.4.1.0 js_of_ocaml-ppx.4.1.0 js_of_ocaml-lwt.4.1.0 \
  sexplib.v0.15.0 ppx_sexp_conv.v0.15.1 \
  yojson.1.7.0 ppx_yojson_conv.v0.15.0 \
  jsonm.1.0.1 \
  ppx_optcomp.v0.15.0 \
  brr.0.0.4 \
  prr.0.1.1 \
  zed.3.2.0 \
  tezt.3.0.0 \
  ocamlformat.0.24.1 \
  ppx_inline_test.v0.15.0 \
  alcotest.1.6.0 \
  qcheck.0.19.1 \
  qcheck-alcotest.0.19.1 \
  && opam clean -y --logs --repo-cache --download-cache --switch-cleanup
