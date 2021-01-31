#!/bin/sh
#
# Creates an ISO from the following built packages.
# Linux, Musl, Toybox, Busybox, LLVM, CMake, Samurai,BYacc, Flex, BMake,
# LibreSSL, Curl, Git, Expat, Zlib, NetBSD-Curses
#
# This should be enough to completely rebuild LazyBox from Source
#

# Create the root fs dir
mkdir isoroot
mkdir isoout

tar -xf pkgs/linux/out/linux.5.10.11.tar.xz -C ./isoroot
tar -xf pkgs/linux/out/linux-dev.5.10.11.tar.xz -C ./isoroot
tar -xf pkgs/musl/out/musl.1.2.2.tar.xz -C ./isoroot
tar -xf pkgs/musl/out/musl-dev.1.2.2.tar.xz -C ./isoroot
tar -xf pkgs/toybox/out/toybox.0.8.4.tar.xz -C ./isoroot
tar -xf pkgs/busybox/out/busybox.1.33.0.tar.xz -C ./isoroot
tar -xf pkgs/llvm/out/llvm.11.0.1.tar.xz -C ./isoroot
tar -xf pkgs/cmake/out/cmake.3.19.2.tar.xz -C ./isoroot
tar -xf pkgs/samurai/out/samurai.1.2.tar.xz -C ./isoroot
tar -xf pkgs/byacc/out/byacc.20210109.tar.xz -C ./isoroot
tar -xf pkgs/bmake/out/bmake.20210110.tar.xz -C ./isoroot
tar -xf pkgs/flex/out/flex.2.6.4.tar.xz -C ./isoroot
tar -xf pkgs/libressl/out/libressl.3.3.1.tar.xz -C ./isoroot
tar -xf pkgs/curl/out/curl.7.74.0.tar.xz -C ./isoroot
tar -xf pkgs/git/out/git.2.30.0.tar.xz -C ./isoroot
tar -xf pkgs/expat/out/expat.2.2.10.tar.xz -C ./isoroot
tar -xf pkgs/zlib/out/zlib.1.2.11.tar.xz -C ./isoroot
tar -xf pkgs/mksh/out/mksh.59c.tar.xz -C ./isoroot
tar -xf pkgs/netbsd-curses/out/netbsd-curses.0.3.1.tar.xz -C ./isoroot


cat >isoroot/init << EOF
#!/bin/sh
exec /sbin/init
EOF

chmod +x isoroot/init

mkdir -p isoroot/etc/init.d/


cat >isoroot/etc/init.d/rcS << EOF
#!/bin/sh
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
mkdir /proc
mkdir /sys
mkdir /tmp
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /tmp

echo 0 > /proc/sys/kernel/printk

ln -s /proc/self/fd/0 /dev/stdin
ln -s /proc/self/fd/1 /dev/stdout
ln -s /proc/self/fd/2 /dev/stderr

busybox mdev -s
busybox mdev -d

mkdir -p /dev/pts
mount -t devpts devpts /dev/pts

hostname -F /etc/hostname

mount -a

#busybox modprobe broadcom
#busybox modprobe tg3
#ifconfig eth0 192.168.2.16
#busybox route add default gw 192.168.2.1
#busybox modprobe radeon

#busybox telnetd

#clear

EOF
chmod +x isoroot/etc/init.d/rcS

cp /etc/inittab isoroot/etc/

cd isoroot
find . | cpio -ov | gzip -9 >../isoout/initramfs.img
cp boot/vmlinuz ../isoout/vmlinuz

cd ../isoout
mkdir -p EFI/BOOT
cp ~/Shell.efi EFI/BOOT/BOOTX64.EFI

cat >startup.nsh << EOF
\vmlinuz initrd=\initramfs.img console=ttyS0 console=tty0


EOF

exit

#dd if=/dev/zero of=lazybox.img count=524288
#fdisk lazybox.img
cd ..
losetup -o 32256 /dev/loop0 lazybox.img
mount /dev/loop0 ./isoroot
rm -r isoroot/*
cp -r isoout/* isoroot
umount ./isoroot
