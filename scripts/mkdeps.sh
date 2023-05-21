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
	base_deps="linux musl mksh toybox busybox libcxx llvm compiler-rt"
	printf "%s\n" $base_deps

	IFS=: set -- $mkdeps
	printf "%s\n" $@
	IFS=: set -- $deps
	printf "%s\n" $@
} | sort | uniq
