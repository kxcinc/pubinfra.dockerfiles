#!/usr/bin/env bash

## Runs an ocaml-general package install script with strict error checking,
## then verifies that every package listed in the script is actually
## installed in the current opam switch.
##
## The install scripts themselves can appear to succeed even when some
## installation step fails (e.g. when invoked as `bash <script>` the shebang
## flags `-xe` are ignored), so use this script to validate them.
##
## usage:
##   ./scripts/check_install_ocaml.sh <ocaml-version|install-script-path>
## examples:
##   ./scripts/check_install_ocaml.sh 5.4
##   ./scripts/check_install_ocaml.sh 5.4.1
##   ./scripts/check_install_ocaml.sh ocaml-general/install_ocaml_5.4_packages.sh

set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)

usage() {
  grep '^##' "$0" | sed 's/^## \{0,1\}//' >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

# resolve the install script from a version number or a path
if [[ -f $1 ]]; then
  install_script=$1
else
  version=$(echo "$1" | cut -d'.' -f1-2)
  install_script="$repo_root/ocaml-general/install_ocaml_${version}_packages.sh"
fi

if [[ ! -f $install_script ]]; then
  echo "error: install script not found: $install_script" >&2
  usage
  exit 2
fi

# guard against running against a switch with a mismatched OCaml version
script_version=$(basename "$install_script" | sed -n 's/^install_ocaml_\(.*\)_packages\.sh$/\1/p')
switch_ocaml=$(opam exec -- ocamlc -vnum)
if [[ -n $script_version && ${switch_ocaml%.*} != "$script_version" ]]; then
  echo "error: current opam switch '$(opam switch show)' has OCaml $switch_ocaml," \
       "but $(basename "$install_script") is for OCaml $script_version" >&2
  echo "hint: switch first, e.g. 'opam switch create $script_version.0' or 'opam switch <name>'" >&2
  exit 2
fi

echo "==> current opam switch: $(opam switch show) (OCaml $switch_ocaml)"
echo "==> running $install_script"
bash -ex -o pipefail "$install_script"

# extract the `packages=( ... )` array literal from the install script
packages=()
eval "$(sed -n '/^packages=(/,/^)/p' "$install_script")"

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "error: could not extract the packages list from $install_script" >&2
  exit 2
fi

echo "==> verifying that ${#packages[@]} packages are installed"
installed=$(opam list --installed --columns=package --short)

result=0
for pkg in "${packages[@]}"; do
  if [[ $pkg == *.* ]]; then
    # name.version: require the exact version to be installed
    found=$(grep -cxF "$pkg" <<<"$installed") || true
  else
    # bare name: any installed version is fine
    found=$(cut -d'.' -f1 <<<"$installed" | grep -cxF "$pkg") || true
  fi
  if [[ $found -eq 0 ]]; then
    echo "NOT INSTALLED: $pkg" >&2
    result=1
  fi
done

if [[ $result -ne 0 ]]; then
  echo "==> FAILED: some packages are missing from the current switch" >&2
  exit 1
fi
echo "==> OK: all packages are installed"
