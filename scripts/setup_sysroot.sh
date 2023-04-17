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
	tar -xf /tmp/$pkg -C sysroot
	rm -f /tmp/$pkg
done

mkdir -p sysroot/tmp
mkdir -p sysroot/proc
mkdir -p sysroot/sys
mkdir -p sysroot/dev
mkdir -p sysroot/build
sudo mount --bind /tmp sysroot/tmp
sudo mount --bind /proc sysroot/proc
sudo mount --bind /sys sysroot/sys
sudo mount --bind /dev sysroot/dev
sudo mount --bind $(pwd) sysroot/build
