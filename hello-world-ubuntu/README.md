## GitHub Container Registry
[https://github.com/orgs/kxcinc/packages/container/package/hello-world-ubuntu](https://github.com/orgs/kxcinc/packages/container/package/hello-world-ubuntu)

## Usage

### Get Docker Image

To get the image, use one of the following methods:

- build Dockerfile
- pull from GitHub Container Registry

#### Build Dockerfile

```bash
$ git clone kxcinc/pubinfra.dockerfiles
$ docker build -t kxcinc/hello-world-ubuntu pubinfra.dockerfiles/hello-world-ubuntu
```

#### Pull from GitHub Container Registry

```bash
$ docker pull ghcr.io/kxcinc/hello-world-ubuntu
```

### Run Image
```bash
$ docker run -it --rm ghcr.io/kxcinc/hello-world-ubuntu
 _______________
< Hello World!! >
 ---------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
$ docker run -it --rm ghcr.io/kxcinc/hello-world-ubuntu -b 'See you!!'
 ___________
< See you!! >
 -----------
        \   ^__^
         \  (==)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
