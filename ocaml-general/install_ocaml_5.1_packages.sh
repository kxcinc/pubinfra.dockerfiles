#!/bin/bash -xe

packages=(
  dune.3.10.0
  merlin
  odoc.2.2.1
  ppxlib.0.30.0
  bisect_ppx.2.8.3
  ppx_deriving.5.2.1
  js_of_ocaml.5.4.0 js_of_ocaml-ppx.5.4.0 js_of_ocaml-lwt.5.4.0
  jsonm.1.0.1
  ezjsonm.1.3.0
  ppx_optcomp.v0.16.0
  brr.0.0.4
  prr.0.1.1
  zed.3.2.0
  ppx_inline_test.v0.16.0
  alcotest.1.7.0
  qcheck.0.21.2
  qcheck-alcotest.0.21.2
  sexplib.v0.16.0 ppx_sexp_conv.v0.16.0
  yojson.2.1.0 ppx_yojson_conv.v0.16.0
  tezt.3.1.1
)

opam install --yes "${packages[@]}" \
  && opam clean -y --logs --repo-cache --download-cache --switch-cleanup

echo -n "exec: "
printf "%s\n" "${packages[@]}" | cut -d'.' -f1 | xargs echo opam show -f package
printf "%s\n" "${packages[@]}" | cut -d'.' -f1 | xargs opam show -f package
