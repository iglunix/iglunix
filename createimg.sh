#!/bin/sh

dd if=../tiny-linux-bootloader/disk of=lazybox.img

TOTAL=`stat -c %s lazybox.img`

SECTOR=$(($TOTAL / 512))

dd if=/dev/zero count=$((3145727 - $SECTOR)) >> lazybox.img


echo "o
n
p
1
32256

a
1
w
" | fdisk lazybox.img

# losetup -o 32256 /dev/loop0 lazybox.img
# mkfs.vfat /dev/loop0
# mount /dev/loop0 ./isoroot
# #rm -r isoroot/*
# #cp -r isoout/* isoroot
# umount ./isoroot
