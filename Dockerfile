FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install wget unzip bc phoronix-test-suite \
  && phoronix-test-suite install pts/build-linux-kernel
