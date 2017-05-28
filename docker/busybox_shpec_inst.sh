#!/bin/sh -ex
# until resolved: https://github.com/rylnd/shpec/pull/117

VERSION=0.3.0

TMPDIR=${TMPDIR:-/tmp}

SHPECDIR=${TMPDIR}/shpec-${VERSION}

cd $TMPDIR
# curl -sL https://github.com/rylnd/shpec/archive/${VERSION}.tar.gz | tar zxf -
curl -sL https://github.com/rylnd/shpec/archive/${VERSION}.tar.gz | gunzip | tar xf -
cd $SHPECDIR
make install
cd $TMPDIR
rm -rf $SHPECDIR