#!/usr/bin/env bash

## Runs the ocaml-general package install script for the given OCaml version
## with strict error checking, then verifies that every package listed in the
## script is actually installed in the current opam switch.
##
## If the current opam switch does not match the given version, offers to
## create (or select) the opam switch for that version first.
##
## The install scripts themselves can appear to succeed even when some
## installation step fails (e.g. when invoked as `bash <script>` the shebang
## flags `-xe` are ignored), so use this script to validate them.
##
## usage:
##   ./scripts/check_install_ocaml.sh <ocaml-version>
## examples:
##   ./scripts/check_install_ocaml.sh 5.4.1
##   ./scripts/check_install_ocaml.sh 4.14.2
##
## environment:
##   CHECK_INSTALL_OCAML_YES=1   answer "y" to the confirmation prompt
##                               automatically (for CI / non-interactive use)

set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)

usage() {
  grep '^##' "$0" | sed 's/^## \{0,1\}//' >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

version=$1

# derive the install script path from the major.minor part of the version
script_version=$(echo "$version" | cut -d'.' -f1-2)
install_script="$repo_root/ocaml-general/install_ocaml_${script_version}_packages.sh"

if [[ ! -f $install_script ]]; then
  echo "error: install script not found: $install_script" >&2
  usage
  exit 2
fi

# decide whether the opam switch for the given version needs to be set up
switch_ocaml=$(opam exec -- ocamlc -vnum 2>/dev/null || true)

if [[ -n $switch_ocaml && ${switch_ocaml%.*} == "$script_version" ]]; then
  target_switch=""
  prompt="install the packages of $(basename "$install_script") into the current opam switch '$(opam switch show)' (OCaml $switch_ocaml)?"
else
  target_switch=$version
  prompt="create/select opam switch '$version' and install the packages of $(basename "$install_script") into it?"
fi

# [y/N] gate; CHECK_INSTALL_OCAML_YES=1 (or y/yes) skips the prompt (for CI)
if [[ ${CHECK_INSTALL_OCAML_YES:-} =~ ^([1yY]|[yY][eE][sS])$ ]]; then
  echo "==> proceeding without prompt (CHECK_INSTALL_OCAML_YES=${CHECK_INSTALL_OCAML_YES})"
else
  read -r -p "==> ${prompt} [y/N] " answer || answer=""
  if [[ ! $answer =~ ^([yY]|[yY][eE][sS])$ ]]; then
    echo "aborted" >&2
    exit 1
  fi
fi

if [[ -n $target_switch ]]; then
  if opam switch list --short 2>/dev/null | grep -qxF "$target_switch"; then
    echo "==> selecting existing opam switch $target_switch"
    opam switch set "$target_switch"
  else
    echo "==> creating opam switch $target_switch"
    opam switch create "$target_switch"
  fi
  switch_ocaml=$(opam exec -- ocamlc -vnum)
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
    actual=$(awk -F'.' -v n="${pkg%%.*}" '$1 == n' <<<"$installed")
    echo "NOT INSTALLED: $pkg (installed: ${actual:-none})" >&2
    result=1
  fi
done

if [[ $result -ne 0 ]]; then
  echo "==> FAILED: some packages are missing from the current switch" >&2
  exit 1
fi
echo "==> OK: all packages are installed"
