#!/bin/mksh
#
# Creates an ISO from the following built packages.
#   mksh bmake gmake libressl cmake curl rsync linux flex
#   byacc om4 zlib samurai libffi python ca-certificates
#   zlib expat gettext-tiny git kati netbsd-curses kakoune
#   iglunix llvm musl
#
# This should be enough to completely rebuild Iglunix from Source
#

# Create the root fs dir

echo "geninitrd.sh"

source build_utils

rm -rf isoout isoroot
mkdir isoroot
mkdir isoout


# This should be a minimal number of packages, if we want fast boot times.
# The remaining packages are in createimg.sh

#packages=(musl mksh bmake gmake libressl cmake curl rsync linux flex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune iglunix)
packages=(musl linux mksh busybox toybox iglunix)
cp_packages ./isoroot

cat >isoroot/init << EOF
#!/bin/sh
exec /sbin/init
EOF

rm isoroot/sbin/init
cat >isoroot/sbin/init << 'EOF'
#!/bin/sh

export PATH=/usr/sbin:/usr/bin:/sbin:/bin
mkdir /proc
mkdir /sys
mkdir /tmp
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /tmp

busybox mdev -s
busybox mdev -d

mkdir /mnt

while ! mount $(findfs LABEL=__IGLUNIX_ROOT) /mnt; do
  echo "Failed to mount boot disk"
  echo "Retrying"
  sleep 0.5
done


echo "Starting switch_root"
#exec switch_root /mnt /etc/init.d/rcS
exec switch_root /mnt /sbin/init

EOF

chmod +x isoroot/init
chmod +x isoroot/sbin/init

# mkdir -p isoroot/etc/init.d/


# cat >isoroot/etc/init.d/rcS << EOF
# #!/bin/sh
# export PATH=/usr/sbin:/usr/bin:/sbin:/bin
# mkdir /proc
# mkdir /sys
# mkdir /tmp
# mount -t proc proc /proc
# mount -t sysfs sysfs /sys
# mount -t tmpfs tmpfs /tmp

# echo 0 > /proc/sys/kernel/printk

# ln -s /proc/self/fd/0 /dev/stdin
# ln -s /proc/self/fd/1 /dev/stdout
# ln -s /proc/self/fd/2 /dev/stderr

# busybox mdev -s
# busybox mdev -d

# mkdir -p /dev/pts
# mount -t devpts devpts /dev/pts

# hostname -F /etc/hostname

# mount -a

# #busybox modprobe broadcom
# #busybox modprobe tg3
# #ifconfig eth0 192.168.2.16
# #busybox route add default gw 192.168.2.1
# #busybox modprobe radeon

# #busybox telnetd

# #clear

# EOF
# chmod +x isoroot/etc/init.d/rcS

# cp /etc/inittab isoroot/etc/

cp /etc/hostname ./isoroot/hostname

cd isoroot
find . | cpio -ov | gzip -9 >../isoout/initramfs.img
cp boot/vmlinuz ../isoout/vmlinuz

# cd ../isoout
# mkdir -p EFI/BOOT
# cp ~/Shell.efi EFI/BOOT/BOOTX64.EFI

# cat >startup.nsh << EOF
# \vmlinuz initrd=\initramfs.img console=ttyS0 console=tty0


# EOF

exit

dd if=/dev/zero of=iglunix.img count=524288
fdisk iglunix.img

#losetup -o 32256 /dev/loop0 iglunix.img
mount /dev/loop0 ./isoroot
rm -r isoroot/*
cp -r isoout/* isoroot
umount ./isoroot
