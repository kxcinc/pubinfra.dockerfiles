# ocaml-general dev doc

## Adding a new OCaml version

### When no install script exists yet for the corresponding major version

1. Add a new install script to the [ocaml-general/](../../ocaml-general/) directory.
2. Run [scripts/check_install_ocaml.sh](../../scripts/check_install_ocaml.sh) with the OCaml version; the installation succeeds if there are no problems with the individual package versions.

   ```console
   $ ./scripts/check_install_ocaml.sh 5.4.1
   ```

   The script asks for confirmation (`[y/N]`) before proceeding; if the current
   opam switch does not match the given version, it offers to create (or select)
   the opam switch for that version first. Set `CHECK_INSTALL_OCAML_YES=1` to
   answer the prompt automatically (for CI / non-interactive use).

   > [!NOTE]
   > Running an install script directly can appear to succeed overall even when
   > an installation step fails along the way. The check script makes the whole
   > run fail on any error, and additionally verifies that every package listed
   > in `packages` is actually installed in the current switch.
3. If it fails, search for the affected packages on [opam](https://opam.ocaml.org/packages/) and update them to versions that are mutually consistent.

### When updating package versions in an existing install script

Verify with the check script in the same way; it offers to create/select the
opam switch for the target version if needed.

```console
$ ./scripts/check_install_ocaml.sh 5.4.1
```

### Verifying inside a Docker container

To verify without touching any local opam switch, use
[scripts/test_install_ocaml_docker.sh](../../scripts/test_install_ocaml_docker.sh).
It builds [ocaml-general/Dockerfile](../../ocaml-general/Dockerfile) for the target
version (the build fails if the installation fails), and then runs
[check_install_ocaml.sh](../../scripts/check_install_ocaml.sh) inside the container
to verify that every package is installed at the specified version.

```console
$ ./scripts/test_install_ocaml_docker.sh 5.4.1

# to pass extra arguments to docker build
$ ./scripts/test_install_ocaml_docker.sh 5.4.1 -- --no-cache --build-arg NODE_VERSION=krypton

# to only verify a pre-built image (used in CI)
$ ./scripts/test_install_ocaml_docker.sh --image ocaml-general-test:5.4.1 5.4.1
```

> [!NOTE]
> The first run takes a while since it builds the entire image, including the
> OCaml compiler. Subsequent runs only re-execute the changed parts of the
> install script thanks to Docker layer caching. If newly published package
> versions are not found, the `opam update` layer is still cached, so re-run
> with `-- --no-cache`.

CI (the `validate-ocaml-general` job in [ocaml-general.yml](../../.github/workflows/ocaml-general.yml))
also automatically runs this verification in `--image` mode against the built image.

### Updating .github/workflows/ocaml-general.yml

Specify the OCaml version in [ocaml-general.yml](../../.github/workflows/ocaml-general.yml).
