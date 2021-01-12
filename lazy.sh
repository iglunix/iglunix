#!/bin/sh
usage() {
	echo $(basename "$0"): ERROR: "$@" 1>&2
	echo usage: $(basename "$0") '([-i]|[-u]|[-f]|[-l]) [-o root]
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
	exit 1
}

find_fail() {
	echo "Package not installed"
	exit 1
}

i= u= l= f= o=

case "$1" in
	-i) i=1;;
	-u) u=1;;
	-l) l=1;;
	-f) f=1;;
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
	stat /tmp/lazybox/$1/usr/share/lazypkg/ >/dev/null || stat_fail
	tar -xf $1 -C /
	rm -r /tmp/lazybox/$1
elif [ "$f" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null || find_fail
	sed -n '/\[fs\]/,$p' /usr/share/lazypkg/$1 | grep -v "\[fs\]"
elif [ "$l" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null || find_fail
	sed -n '/\[license\]/,/\[fs\]/{/\[license\]\|\[fs\]/!p}' /usr/share/lazypkg/$1
fi
