FROM ubuntu-debootstrap:14.04
ENV PREFIX_DIR /usr/glibc-compat
ENV GLIBC_VERSION 2.23
RUN apt-get -q update \
	&& apt-get -qy install build-essential wget openssl gawk linux-headers-generic g++-multilib libc6-dev-i386
COPY configparams /glibc-build/configparams
COPY builder /builder
ENTRYPOINT ["/builder"]
