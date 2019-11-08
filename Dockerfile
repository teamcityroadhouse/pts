FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

# Install PTS
RUN export url='http://phoronix-test-suite.com/releases/' && \
    export version='9.0.1' && \
    export sha256sum='a117a4350774e67989d90bf0b5e82a8072652f8caa60a62c3e5f' && \
    apt-get update -qq && \
    apt-get install -qqy ca-certificates curl unzip php-cli php-xml procps &&\
    apt-get install -qqy build-essential autoconf bc bison libssl-dev mesa-utils unzip apt-file flex &&\
    echo "downloading phoronix-test-suite-${version}.tar.gz ..." && \
    curl -LSs "${url}phoronix-test-suite-${version}.tar.gz" -o pts.tgz && \
    sha256sum pts.tgz | grep -q "$sha256sum" || \
        { echo "expected $sha256sum, got $(sha256sum pts.tgz)"; exit 13; } && \
    tar xf pts.tgz && \
    (cd phoronix-test-suite && ./install-sh) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* phoronix-test-suite pts.tgz && \
    rm /usr/share/phoronix-test-suite/pts-core/objects/pts_openbenchmarking_upload.php

# Batch mode created with batch-setup
COPY phoronix-test-suite.xml /etc/

# Install benchmarks
RUN phoronix-test-suite batch-install pts/build-linux-kernel

CMD phoronix-test-suite batch-benchmark pts/build-linux-kernel
