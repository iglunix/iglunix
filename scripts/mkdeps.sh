#!/bin/sh -e

auto_cross() {
	return
}

if [ ! -e ./$1/build.sh ]
then
	printf '%s/build.sh does not exist\n' "$1"
	false
fi

. ./$1/build.sh

{
	base_deps="linux musl mksh toybox busybox libcxx llvm compiler-rt iglupkg xbps zstd zlib-ng libarchive"
	printf "%s\n" $base_deps

	IFS=: set -- $mkdeps
	if [ ! -z "$1" ]
	then
		printf "%s\n" $@
	fi

	IFS=: set -- $deps
	if [ ! -z "$1" ]
	then
		printf "%s\n" $@
	fi
} | sort | uniq
