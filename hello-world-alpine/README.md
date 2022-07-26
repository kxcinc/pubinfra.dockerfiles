## GitHub Container Registry
[https://github.com/orgs/kxcteam/packages/container/package/hello-world-alpine](https://github.com/orgs/kxcteam/packages/container/package/hello-world-alpine)

## Usage

### Get Docker Image

To get the image, use one of the following methods:

- build Dockerfile
- pull from GitHub Container Registry

#### Build Dockerfile

```bash
$ git clone kxcteam/pubinfra.dockerfiles
$ docker build -t kxcteam/hello-world-alpine pubinfra.dockerfiles/hello-world-alpine
```

#### Pull from GitHub Container Registry

```bash
$ docker pull ghcr.io/kxcteam/hello-world-alpine
```

### Run Image
```bash
$ docker run -it --rm kxcteam/hello-world-alpine
 _______________
< Hello World!! >
 ---------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
$ docker run -it --rm kxcteam/hello-world-alpine -b 'See you!!'
 ___________
< See you!! >
 -----------
        \   ^__^
         \  (==)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
