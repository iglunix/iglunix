#!/bin/sh -ex

MIRROR=https://mirror.iglunix.org/$(uname -m)

mkdir -p cache
if [ -e sysroot ]
then
	sudo umount sysroot/tmp
	sudo umount sysroot/proc
	sudo umount sysroot/sys
	sudo umount sysroot/dev
	sudo umount sysroot/build
	rm -rf sysroot
fi

mkdir -p sysroot

for dep in $(./scripts/mkdeps.sh "$1")
do
	if [ ! -e cache/$dep.tar.zst ]
	then
		curl $MIRROR/$dep.tar.zst -o cache/$dep.tar.zst
	fi

	tar -xf cache/$dep.tar.zst -C sysroot
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

mkdir -p sysroot/etc
cat > sysroot/etc/passwd << EOF
root:x:0:0:Admin,,,:/root:/bin/sh
EOF

cat > sysroot/etc/group << EOF
root:x:0:
EOF
