FROM ubuntu:latest
MAINTAINER Nima Rafati <nimarafati@gmail.com>

# install samtools
ARG SAMTOOLS_VERSION=1.9
RUN apt-get update && \ 
    apt-get -y install bash tar wget bzip2 gcc g++ make zlib1g-dev libncurses5-dev liblzma-dev libbz2-dev pigz libcurl4-openssl-dev && \ 
    wget "https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2" && \
    tar xjvf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-${SAMTOOLS_VERSION}