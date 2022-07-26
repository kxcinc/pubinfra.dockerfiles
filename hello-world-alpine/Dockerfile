FROM alpine:latest


RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --no-cache add cowsay@testing

ENTRYPOINT ["/usr/bin/cowsay"]
CMD ["Hello World!!"]
