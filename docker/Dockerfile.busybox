FROM progrium/busybox:latest

RUN \
    # workaround for: https://github.com/progrium/busybox/issues/32
    mv /lib/libgcc_s.so.1 /lib/libgcc_s.so.1.bak && \
    opkg-install curl ca-certificates make coreutils-timeout && \
    sh -c "`curl -L https://raw.github.com/rylnd/shpec/master/install.sh`"

VOLUME "/tmp/wtfc"
WORKDIR "/tmp/wtfc"

CMD sh -c shpec