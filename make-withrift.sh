#!/bin/bash

(set -x; brew install autoconf automake libtool pkg-config)
(set -x; brew install openssl)

set -e
openssl_version=$(ls -t /usr/local/Cellar/openssl | head -1)
bison_version=$(ls -t /usr/local/Cellar/bison | head -1)

export PATH=/usr/local/Cellar/openssl/$openssl_version/bin:/usr/local/Cellar/bison/$bison_version/bin:$PATH

[ -f Makefile ] || (set -x; ./configure --with-openssl=/usr/local/Cellar/openssl/$openssl_version --without-csharp --without-erlang --without-python --without-perl --without-php --without-php_extension --without-haskell)

ncpu=$(sysctl -n hw.ncpu)
(set -x; cd compiler/cpp && make -j$ncpu) && cp -v compiler/cpp/thrift $GOPATH/src/github.com/parsable/mothership/thrift/withrift
