#!/usr/bin/env bash

## Builds the ocaml-general Docker image for the given OCaml version and runs
## scripts/check_install_ocaml.sh inside the resulting container, so that the
## package install scripts can be tested without touching any local opam
## switch. Usable both locally and in CI.
##
## usage:
##   ./scripts/test_install_ocaml_docker.sh [--image <image>] <ocaml-version> [-- <extra docker build args>]
##
## examples:
##   # build the image locally and verify the package installation
##   ./scripts/test_install_ocaml_docker.sh 5.4.1
##
##   # pass extra args to docker build
##   ./scripts/test_install_ocaml_docker.sh 5.4.1 -- --no-cache --build-arg NODE_VERSION=krypton
##
##   # verify a pre-built image without building it (e.g. in CI)
##   ./scripts/test_install_ocaml_docker.sh --image ocaml-general-test:5.4.1 5.4.1

set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)

usage() {
  grep '^##' "$0" | sed 's/^## \{0,1\}//' >&2
}

image=""
version=""
build_args=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --image)
      if [[ $# -lt 2 ]]; then usage; exit 2; fi
      image=$2
      shift 2 ;;
    --)
      shift
      build_args=("$@")
      break ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage
      exit 2 ;;
    *)
      if [[ -n $version ]]; then
        echo "error: multiple versions given: $version, $1" >&2
        usage
        exit 2
      fi
      version=$1
      shift ;;
  esac
done

if [[ -z $version ]]; then
  usage
  exit 2
fi

script_version=$(echo "$version" | cut -d'.' -f1-2)
install_script_filename="install_ocaml_${script_version}_packages.sh"
if [[ ! -f "$repo_root/ocaml-general/$install_script_filename" ]]; then
  echo "error: install script not found: ocaml-general/$install_script_filename" >&2
  exit 2
fi

if [[ -z $image ]]; then
  image="ocaml-general-test:$version"
  echo "==> building $image (OCAML_VERSION=$version)"
  # a failed package installation fails the docker build, hence this script
  docker build \
    --build-arg OCAML_VERSION="$version" \
    --build-arg PACKAGE_INSTALL_SCRIPT_FILENAME="$install_script_filename" \
    ${build_args[@]+"${build_args[@]}"} \
    --tag "$image" \
    "$repo_root/ocaml-general"
else
  echo "==> using existing image: $image (skipping docker build)"
fi

# verify inside the container that every listed package is actually installed
echo "==> running check_install_ocaml.sh inside $image"
docker run --rm \
  --volume "$repo_root:/repo:ro" \
  "$image" \
  bash /repo/scripts/check_install_ocaml.sh "$version"

echo "==> OK: docker install test passed for OCaml $version"
