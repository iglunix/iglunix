#!/bin/mksh
#
# Creates an ISO from the following built packages.
#   mksh bmake gmake libressl cmake curl rsync linux flex
#   byacc om4 zlib samurai libffi python ca-certificates
#   zlib expat gettext-tiny git kati netbsd-curses kakoune
#   lazybox
#
# This should be enough to completely rebuild LazyBox from Source
#

# Create the root fs dir
mkdir isoroot
mkdir isoout

mkdir diskroot

cp_packages (){
	#NOTE: this will assume that there always is a '*-dev'/'*-doc' package,\n this is not true.
	# That's why the errors are shown to some one who cares.
	for pkg in ${packages[@]}
	do
		echo "Going to copy: $pkg to $1"
		tar -xf pkgs/${pkg}/out/${pkg}.*.tar.xz -C $1
		tar -xf pkgs/${pkg}/out/${pkg}-dev.*.tar.xz -C $1 2> /dev/null
		tar -xf pkgs/${pkg}/out/${pkg}-doc.*.tar.xz -C $1 2> /dev/null
	done
}

#packages=(musl mksh bmake gmake libressl cmake curl rsync linux flex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune lazybox)
packages=(musl linux mksh busybox toybox lazybox)
cp_packages ./isoroot

#packages=(musl mksh busybox toybox llvm bmake gmake libressl cmake curl rsync linux flex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune lazybox rust less heirloom-doctools file pci-ids)
#cp_packages ./diskroot

cat >isoroot/init << EOF
#!/bin/sh
exec /sbin/init
EOF

rm isoroot/sbin/init
cat >isoroot/sbin/init << EOF
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

exec /bin/sh

mkdir /mnt

# while not mount $(blkid -L LAZYBOX_BS_MEDIA) /mnt; do
# 	echo "Failed to mount boot disk"
# 	echo "Retrying"
# 	sleep 0.5
# done

exec switch_root /mnt

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

dd if=/dev/zero of=lazybox.img count=524288
fdisk lazybox.img

#losetup -o 32256 /dev/loop0 lazybox.img
mount /dev/loop0 ./isoroot
rm -r isoroot/*
cp -r isoout/* isoroot
umount ./isoroot
