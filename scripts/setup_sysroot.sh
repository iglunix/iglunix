#!/bin/sh -e

if [ ! -f pkgs.tar.zst ]
then
	printf 'ERROR: must download pkgs.tar.zst first'
	false
fi

mkdir -p sysroot

for pkg in $(tar -tf pkgs.tar.zst)
do
	tar -C /tmp -xf pkgs.tar.zst $pkg
	ls /tmp
	tar -xf /tmp/$pkg -C sysroot
	rm -f /tmp/$pkg
done

mkdir -p sysroot/tmp
mkdir -p sysroot/proc
mkdir -p sysroot/sys
mkdir -p sysroot/dev
mkdir -p sysroot/build
mount --bind /tmp sysroot/tmp
mount --bind /proc sysroot/proc
mount --bind /sys sysroot/sys
mount --bind /dev sysroot/dev
mount --bind $(pwd) sysroot/build
