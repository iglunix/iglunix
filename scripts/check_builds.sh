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

$IGLUPKG f

cd $BASE

sudo chroot ./sysroot /build/scripts/check_builds_chroot.sh
