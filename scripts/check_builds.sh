#!/bin/sh -e

if [ ! -d ./sysroot ]
then
	printf 'ERROR: sysroot not setup'
	false
fi

if [ ! -d "$1" ]
then
	printf 'ERROR: package %s does not exist' "$1"
	false
fi

BASE=$(pwd)
SYSROOT=$BASE/sysroot
IGLUPKG=$BASE/sysroot/usr/bin/iglupkg
cd "$1"

sh -e -x $IGLUPKG f

cd $BASE

sudo chroot ./sysroot /build/scripts/check_builds_chroot.sh "$1"

mkdir -p out

if [ -e "$1"/out/*.tar ]
then
	zstd --ultra -22 "$1"/out/*.tar -o out/$(basename "$1").tar.zst
else
	cp "$1"/out/*.tar.zst out/$(basename "$1").tar.zst
fi

if [ -e ~/.ssh/mirror.key ]
then
	scp -i ~/.ssh/mirror.key \
	out/$(basename "$1").tar.zst \
	root@mirror.iglunix.org:/srv/http/mirror/x86_64/$(basename "$1").tar.zst
fi
