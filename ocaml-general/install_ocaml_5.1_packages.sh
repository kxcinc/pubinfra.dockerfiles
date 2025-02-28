#!/bin/bash -xe

packages=(
  dune.3.17.2
  dune-build-info.3.17.2
  merlin
  odoc.2.4.4
  ppxlib.0.35.0
  bisect_ppx.2.8.3
  ppx_deriving.6.0.3
  js_of_ocaml.6.0.1 js_of_ocaml-ppx.6.0.1 js_of_ocaml-lwt.6.0.1
  jsonm.1.0.2
  ezjsonm.1.3.0
  ppx_optcomp.v0.17.0
  brr.0.0.7
  prr.0.1.1
  zed.3.2.3
  ppx_inline_test.v0.17.0
  alcotest.1.8.0
  qcheck.0.23
  qcheck-alcotest.0.23
  sexplib.v0.17.0 ppx_sexp_conv.v0.17.0
  yojson.2.2.2 ppx_yojson_conv.v0.17.0
  tezt.4.2.0
  melange.5.0.1-51
  uuidm.0.9.9
  bigstringaf.0.10.0
  angstrom.0.16.1
  uri.4.4.0
)

pins=(
  dune 3.17.2
  dune-action-plugin 3.17.2
  dune-build-info 3.17.2
  dune-configurator 3.17.2
  dune-glob 3.17.2
  dune-private-libs 3.17.2
  dune-rpc 3.17.2
  dune-rpc-lwt 3.17.2
  dune-site 3.17.2
)

echo "${pins[@]}" | xargs -n 2 opam pin -n add

opam install --yes "${packages[@]}" \
  && opam clean -y --logs --repo-cache --download-cache --switch-cleanup

echo -n "exec: "
printf "%s\n" "${packages[@]}" | cut -d'.' -f1 | xargs echo opam show -f package
printf "%s\n" "${packages[@]}" | cut -d'.' -f1 | xargs opam show -f package
