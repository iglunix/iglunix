#!/bin/sh


# TOTAL=`stat -c %s iglunix.img`

# SECTOR=$(($TOTAL / 512))

# dd if=/dev/zero count=$((3145727 - $SECTOR)) >> iglunix.img


dd if=../tiny-linux-bootloader/disk of=iglunix.img
#dd if=/dev/zero count=32768 > iglunix.img
dd if=/dev/zero bs=1 count=0 seek=1G of=./iglunix.img

echo "o
n
p
1
45505

a
1
w
" | fdisk iglunix.img


#dd conv=notrunc bs=1 count=446 if=../tiny-linux-bootloader/disk of=iglunix.img
#dd conv=notrunc bs=1 skip=510 seek=510 if=../tiny-linux-bootloader/disk of=iglunix.img

# losetup -o 32256 /dev/loop0 iglunix.img
# mkfs.vfat /dev/loop0
# mount /dev/loop0 ./isoroot
# #rm -r isoroot/*
# #cp -r isoout/* isoroot
# umount ./isoroot
