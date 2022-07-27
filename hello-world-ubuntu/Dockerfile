FROM ubuntu:22.04

ENV DEBIAN_FRONTEND_OLD=$DEBIAN_FRONTEND

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  cowsay \
  && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND_OLD

ENTRYPOINT ["/usr/games/cowsay"]
CMD ["Hello World!!"]
