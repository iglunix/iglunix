#!/bin/sh -ex

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

find sysroot
sudo chroot ./sysroot /build/scripts/check_builds_chroot.sh "$1"

mkdir -p out

if [ -e ~/.ssh/mirror.key ]
then
	XBPS_PASSPHRASE="$2" xbps-rindex --privkey ~/.ssh/xbps.key \
	--sign-pkg "$1"/out/*.xbps --signedby 'mirror <mirror@iglunix.org>'

	scp -i ~/.ssh/mirror.key \
	"$1"/out/*.xbps "$1"/out/*.xbps.sig \
	root@mirror.iglunix.org:/srv/http/mirror/
fi
