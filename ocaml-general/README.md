## usage

- `docker pull ghcr.io/kxcteam/ocaml-general:$TAG`, see below for spec
- see https://github.com/kxcteam/pubinfra.dockerfiles/pkgs/container/ocaml-general for available tags

## tag convention
- `${ocaml-version}`
  -  (hopefully) alias for `ubuntu.22.04-ocaml.${ocaml-version}-node.${some-random-version}-amd64`
- `${os}-ocaml.${ocaml-verion}-node.${nodejs-version}-${arch}`
  - `${os}` could now be `ubuntu.22.04`
  - `${arch}` could now be `arm64` or `amd64`
