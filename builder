#!/usr/bin/env bash

set -eo pipefail; [[ "$TRACE" ]] && set -x

main() {
	declare version="${1:-$GLIBC_VERSION}" prefix="${2:-$PREFIX_DIR}"

	: "${version:?}" "${prefix:?}"

	{
		wget -qO- "http://ftp.gnu.org/gnu/glibc/glibc-$version.tar.gz" \
			| tar zxf -
		mkdir -p /glibc-build && cd /glibc-build
		"/glibc-$version/configure" \
			--prefix="$prefix" \
			--libdir="$prefix/lib" \
			--libexecdir="$prefix/lib" \
			--host=i686-linux-gnu \
			--build=i686-linux-gnu \
			CC="gcc -m32" CXX="g++ -m32" \
			CFLAGS="-O2 -march=i686" \
			CXXFLAGS="-O2 -march=i686"
		make && make install
		tar --hard-dereference -zcf "/glibc-bin-$version.tar.gz" "$prefix"
	} >&2

	[[ $STDOUT ]] && cat "/glibc-bin-$version.tar.gz"
}

main "$@"
