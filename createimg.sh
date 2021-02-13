#!/bin/sh

rm iglunix.img

dd if=../tiny-linux-bootloader/disk of=iglunix.img

FILE_SIZE=$(stat -c %s iglunix.img)
echo "FILE_SIZE=${FILE_SIZE}"
PARTITION_START=$(($FILE_SIZE / 512))
PARTITION_START=$(($PARTITION_START + 1))
echo "PARTITION_START=${PARTITION_START}"

#create room for a  partition
ls -al iglunix.img  -h
dd if=/dev/zero bs=1 count=0 seek=1G of=iglunix.img
ls -al iglunix.img  -h

echo "o
n
p
1
${PARTITION_START}

w
" | fdisk iglunix.img

exit

# losetup -o 32256 /dev/loop0 iglunix.img
# mkfs.vfat /dev/loop0
# mount /dev/loop0 ./isoroot
# #rm -r isoroot/*
# #cp -r isoout/* isoroot
# umount ./isoroot
