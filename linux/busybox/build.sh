pkgver=1.36.1
pkgname=busybox
bad=gmake
deps="musl"
pkgrel=1

fetch() {
	curl "https://busybox.net/downloads/busybox-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	# patch -p1 < ../../clang-fix.patch
	# patch -p1 < ../../modprobe.patch
	# cp ../man.sh .
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake HOSTCC=cc CC=$CC CFLAGS=-O0 defconfig
	bad --gmake gmake HOSTCC=cc CC=$CC CFLAGS=-O0
	bad --gmake gmake HOSTCC=cc CC=$CC CFLAGS=-O0 install
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir
	cp -r ./_install/* $pkgdir
	chmod 4755 $pkgdir/bin/busybox

	install -d $pkgdir/etc/profile.d
	# install -Dm755 ../man.sh $pkgdir/etc/profile.d

	install -Dm755 ./examples/udhcp/simple.script $pkgdir/usr/share/udhcpc/default.script

	rm $pkgdir/linuxrc
	rm $pkgdir/bin/ln
	rm $pkgdir/bin/uname
	rm $pkgdir/usr/bin/install
	rm $pkgdir/usr/bin/lspci
	rm $pkgdir/bin/cat
	rm $pkgdir/bin/chattr
	rm $pkgdir/bin/chgrp
	rm $pkgdir/bin/chmod
	rm $pkgdir/bin/chown
	rm $pkgdir/bin/cp
	rm $pkgdir/bin/cpio
	rm $pkgdir/bin/date
	rm $pkgdir/bin/dmesg
	rm $pkgdir/bin/dnsdomainname
	rm $pkgdir/bin/echo
	rm $pkgdir/bin/egrep
	rm $pkgdir/bin/false
	rm $pkgdir/bin/fgrep
	rm $pkgdir/bin/fsync
	rm $pkgdir/bin/grep
	rm $pkgdir/bin/hostname
	rm $pkgdir/bin/kill
	rm $pkgdir/bin/login
	rm $pkgdir/bin/ls
	rm $pkgdir/bin/lsattr
	rm $pkgdir/bin/mkdir
	rm $pkgdir/bin/mknod
	rm $pkgdir/bin/mktemp
	rm $pkgdir/bin/mount
	rm $pkgdir/bin/mountpoint
	rm $pkgdir/bin/mv
	rm $pkgdir/bin/netstat
	rm $pkgdir/bin/nice
	rm $pkgdir/bin/pidof
	rm $pkgdir/bin/printenv
	rm $pkgdir/bin/ps
	rm $pkgdir/bin/pwd
	rm $pkgdir/bin/rm
	rm $pkgdir/bin/rmdir
	rm $pkgdir/bin/sed
	rm $pkgdir/bin/sleep
	rm $pkgdir/bin/stat
	rm $pkgdir/bin/su
	rm $pkgdir/bin/sh
	rm $pkgdir/bin/sync
	rm $pkgdir/bin/touch
	rm $pkgdir/bin/true
	rm $pkgdir/bin/umount
	rm $pkgdir/bin/usleep
	rm $pkgdir/bin/tar

	rm $pkgdir/sbin/blockdev
	rm $pkgdir/sbin/freeramdisk
	rm $pkgdir/sbin/halt
	rm $pkgdir/sbin/hwclock
	rm $pkgdir/sbin/ifconfig
	rm $pkgdir/sbin/insmod
	rm $pkgdir/sbin/losetup
	rm $pkgdir/sbin/lsmod
	rm $pkgdir/sbin/mkswap
	rm $pkgdir/sbin/modinfo
	rm $pkgdir/sbin/pivot_root
	rm $pkgdir/sbin/poweroff
	rm $pkgdir/sbin/reboot
	rm $pkgdir/sbin/rmmod
	rm $pkgdir/sbin/swapoff
	rm $pkgdir/sbin/swapon
	rm $pkgdir/sbin/switch_root
	rm $pkgdir/sbin/sysctl
	rm $pkgdir/sbin/vconfig

	rm $pkgdir/usr/bin/basename
	rm $pkgdir/usr/bin/bunzip2
	rm $pkgdir/usr/bin/bzcat
	rm $pkgdir/usr/bin/cal
	rm $pkgdir/usr/bin/chrt
	rm $pkgdir/usr/bin/chvt
	rm $pkgdir/usr/bin/clear
	rm $pkgdir/usr/bin/cmp
	rm $pkgdir/usr/bin/comm
	rm $pkgdir/usr/bin/cut
	rm $pkgdir/usr/bin/dirname
	rm $pkgdir/usr/bin/du
	rm $pkgdir/usr/bin/eject
	rm $pkgdir/usr/bin/env
	rm $pkgdir/usr/bin/expand
	rm $pkgdir/usr/bin/factor
	rm $pkgdir/usr/bin/fallocate
	rm $pkgdir/usr/bin/find
	rm $pkgdir/usr/bin/flock
	rm $pkgdir/usr/bin/free
	rm $pkgdir/usr/bin/ftpget
	rm $pkgdir/usr/bin/ftpput
	rm $pkgdir/usr/bin/groups
	rm $pkgdir/usr/bin/head
	rm $pkgdir/usr/bin/hexedit
	rm $pkgdir/usr/bin/id
	rm $pkgdir/usr/bin/killall
	rm $pkgdir/usr/bin/less
	rm $pkgdir/usr/bin/logger
	rm $pkgdir/usr/bin/logname
	rm $pkgdir/usr/bin/lsusb
	rm $pkgdir/usr/bin/md5sum
	rm $pkgdir/usr/bin/microcom
	rm $pkgdir/usr/bin/mkfifo
	rm $pkgdir/usr/bin/mkpasswd
	rm $pkgdir/usr/bin/nc
	rm $pkgdir/usr/bin/nl
	rm $pkgdir/usr/bin/nohup
	rm $pkgdir/usr/bin/nproc
	rm $pkgdir/usr/bin/nsenter
	rm $pkgdir/usr/bin/od
	rm $pkgdir/usr/bin/passwd
	rm $pkgdir/usr/bin/paste
	rm $pkgdir/usr/bin/patch
	rm $pkgdir/usr/bin/pgrep
	rm $pkgdir/usr/bin/pkill
	rm $pkgdir/usr/bin/pmap
	rm $pkgdir/usr/bin/printf
	rm $pkgdir/usr/bin/pwdx
	rm $pkgdir/usr/bin/readlink
	rm $pkgdir/usr/bin/realpath
	rm $pkgdir/usr/bin/renice
	rm $pkgdir/usr/bin/reset
	rm $pkgdir/usr/bin/seq
	rm $pkgdir/usr/bin/setfattr
	rm $pkgdir/usr/bin/setsid
	rm $pkgdir/usr/bin/sha1sum
	rm $pkgdir/usr/bin/shred
	rm $pkgdir/usr/bin/sort
	rm $pkgdir/usr/bin/split
	rm $pkgdir/usr/bin/strings
	rm $pkgdir/usr/bin/tac
	rm $pkgdir/usr/bin/tail
	rm $pkgdir/usr/bin/taskset
	rm $pkgdir/usr/bin/tee
	rm $pkgdir/usr/bin/test
	rm $pkgdir/usr/bin/time
	rm $pkgdir/usr/bin/timeout
	rm $pkgdir/usr/bin/top
	rm $pkgdir/usr/bin/truncate
	rm $pkgdir/usr/bin/tty
	rm $pkgdir/usr/bin/uniq
	rm $pkgdir/usr/bin/unlink
	rm $pkgdir/usr/bin/unshare
	rm $pkgdir/usr/bin/uptime
	rm $pkgdir/usr/bin/uudecode
	rm $pkgdir/usr/bin/uuencode
	rm $pkgdir/usr/bin/w
	rm $pkgdir/usr/bin/wc
	rm $pkgdir/usr/bin/which
	rm $pkgdir/usr/bin/who
	rm $pkgdir/usr/bin/whoami
	rm $pkgdir/usr/bin/xargs
	rm $pkgdir/usr/bin/xxd
	rm $pkgdir/usr/bin/yes

	rm $pkgdir/usr/sbin/chroot
	rm $pkgdir/usr/sbin/fsfreeze

	rm $pkgdir/usr/bin/man
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
