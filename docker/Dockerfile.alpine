FROM alpine:latest

ARG SHELL_NAME
ARG SHELL_PKG

RUN \
# Repository pinning: https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
    echo "@testing http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache --update ${SHELL_PKG} openssl curl make && \
    rm -f /tmp/* /etc/apk/cache/* && \
    sh -c "`curl -L https://raw.github.com/rylnd/shpec/master/install.sh`"

ENV SHELL ${SHELL_NAME}

VOLUME "/tmp/wtfc"
WORKDIR "/tmp/wtfc"

CMD ${SHELL} -c shpec