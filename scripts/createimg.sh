#!/bin/sh

echo "Createimg.sh"

rm iglunix.img

dd if=/tiny-linux-bootloader/disk of=iglunix.img

source build_utils

FILE_SIZE=$(stat -c %s iglunix.img)
echo "FILE_SIZE=${FILE_SIZE}"
PARTITION_START=$(($FILE_SIZE / 512))
PARTITION_START=$(($PARTITION_START + 1))
echo "PARTITION_START=${PARTITION_START}"

#create room for a  partition
ls -al iglunix.img  -h
dd if=/dev/zero bs=1 count=0 seek=2560M of=iglunix.img
ls -al iglunix.img  -h

echo "n
p
1
${PARTITION_START}

w
" | fdisk iglunix.img

PARTITION_START2=$((${PARTITION_START} * 512))
echo "PARTITION_START2: ${PARTITION_START2}"
LOOPBACK=$(losetup -o ${PARTITION_START2} -s -f iglunix.img)
echo "loopback interface: ${LOOPBACK}"

#ERROR IF NO LOOPBACK
[ -z "$LOOPBACK" ] && echo "loopback creation failed!" && exit -1

mke2fs -t ext4 -L "__IGLUNIX_ROOT" ${LOOPBACK}

ROOT=/mnt/__IGLUNIX_ROOT
umount ${ROOT}
rm -rf ${ROOT}

mkdir -p ${ROOT}
mount ${LOOPBACK} ${ROOT}

packages=(musl mksh bmake gmake llvm libressl mandoc cmake curl rsync reflex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune iglunix rust toybox busybox less pci-ids e2fsprogs util-linux linux-pam kbd)
cp_packages ${ROOT}

echo "Linked ld.lld (from llvm) to ld"
ln -s ${ROOT}/usr/bin/ld.lld ${ROOT}/usr/bin/ld

echo "Copying misc files & creating misc dirs for live-usb"
mkdir ${ROOT}/proc/
mkdir ${ROOT}/dev/
mkdir ${ROOT}/tmp/
mkdir ${ROOT}/sys/

mkdir ${ROOT}/mnt/
mkdir ${ROOT}/etc/
mkdir ${ROOT}/root/
cp ./pkgs/tiny-linux-bootloader/fstab ${ROOT}/etc/fstab
cp ./etc/hostname ${ROOT}/etc/hostname
cp ./etc/passwd  ${ROOT}/etc/passwd
cp ./etc/group  ${ROOT}/etc/group
touch ${ROOT}/etc/shadow

echo "Using the host keymap"
cp /etc/vconsole.conf ${ROOT}/etc/vconsole.conf 
#TODO: this is a systemd file,
#      use udev/kbd

echo "Copying init.d files& inittab"
mkdir ${ROOT}/etc/init.d/
cp -r ./init/init.d ${ROOT}/etc/
cp ./init/inittab ${ROOT}/etc/

echo "Unmounting & closing loopback"

#umount ${ROOT}

#losetup -d ${LOOPBACK}

#zstd iglunix.img --ultra -22 -T
exit

# losetup -o 32256 /dev/loop0 iglunix.img
# mkfs.vfat /dev/loop0
# mount /dev/loop0 ./isoroot
# #rm -r isoroot/*
# #cp -r isoout/* isoroot
# umount ./isoroot
