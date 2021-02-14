#!/bin/sh

echo "Createimg.sh"

rm iglunix.img

dd if=../tiny-linux-bootloader/disk of=iglunix.img

source build_utils

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

PARTITION_START2=$((${PARTITION_START} * 512))
echo "PARTITION_START2: ${PARTITION_START2}"
LOOPBACK=$(losetup -o ${PARTITION_START2} -s -f iglunix.img)
echo "LOOPBACK: ${LOOPBACK}"
mke2fs -t ext4 -L "__IGLUNIX_ROOT" ${LOOPBACK}

umount /mnt/__IGLUNIX_ROOT
rm -rf /mnt/__IGLUNIX_ROOT

mkdir -p /mnt/__IGLUNIX_ROOT
mount ${LOOPBACK} /mnt/__IGLUNIX_ROOT

packages=(musl mksh bmake gmake libressl cmake curl rsync flex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune iglunix rust toybox busybox less file pci-ids e2fsprogs)
cp_packages /mnt/__IGLUNIX_ROOT

echo "Unmounting & closing loopback"

umount /mnt/__IGLUNIX_ROOT

losetup -d ${LOOPBACK}
exit

# losetup -o 32256 /dev/loop0 iglunix.img
# mkfs.vfat /dev/loop0
# mount /dev/loop0 ./isoroot
# #rm -r isoroot/*
# #cp -r isoout/* isoroot
# umount ./isoroot
