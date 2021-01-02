#!/bin/sh
usage() {
	echo $(basename "$0"): ERROR: "$@" 1>&2
	echo usage: $(basename "$0") '([-i]|[-u]) [-o root]
		[pkg.tar]' 1>&2
	exit 1
}

tar_fail() {
	echo "Failed to extract tar"
	exit 1
}

stat_fail() {
	echo "Not a valid package"
	echo "Missing package meta file"
}

i= u= f= o=

case "$1" in
	-i) i=1;;
	-u) u=1;;
	*) usage "bad argument $i";;
esac
shift

while :
do
    case "$1" in
	-o) shift; o="$1";;
	--) shift; break;;
	-*) usage "bad argument $1";;
	*) break;;
    esac
    shift
done

if [ "$i" = "1" ]; then
	echo "Installing $1"
	mkdir -p /tmp/lazybox/$1 || exit 1
	tar -xf $1 -C /tmp/lazybox/$1 || tar_fail
	stat /tmp/lazybox/$1/lib/lazypkg/ >/dev/null || stat_fail
	tar -xf $1 -C /
	rm -r /tmp/lazybox/$1
fi
