## GitHub Container Registry
[https://github.com/orgs/kxcinc/packages/container/package/hello-world-alpine](https://github.com/orgs/kxcinc/packages/container/package/hello-world-alpine)

## Usage

### Get Docker Image

To get the image, use one of the following methods:

- build Dockerfile
- pull from GitHub Container Registry

#### Build Dockerfile

```bash
$ git clone kxcinc/pubinfra.dockerfiles
$ docker build -t kxcinc/hello-world-alpine pubinfra.dockerfiles/hello-world-alpine
```

#### Pull from GitHub Container Registry

```bash
$ docker pull ghcr.io/kxcinc/hello-world-alpine
```

### Run Image
```bash
$ docker run -it --rm ghcr.io/kxcinc/hello-world-alpine
 _______________
< Hello World!! >
 ---------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
$ docker run -it --rm ghcr.io/kxcinc/hello-world-alpine -b 'See you!!'
 ___________
< See you!! >
 -----------
        \   ^__^
         \  (==)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
