pkgname=e2fsprogs
pkgver=1.45.6
bad="gmake"


ifetch() {
	curl -L "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v$pkgver/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver

	echo "$pkgdir"
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \

	#--exec_prefix=/

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	# Doesn't work :(
	#gmake install DESTDIR=$pkgdir PREFIX=/usr

	# We're not moving util/subst
	# Do we need to? IDK
	
	mkdir -p $pkgdir/usr/bin
	mkdir -p $pkgdir/usr/lib
	
	
	mv misc/badblocks misc/blkid misc/chattr misc/dumpe2fs misc/e2freefrag misc/e2fuzz misc/e2image \
	   misc/e2initrd_helper misc/e2undo misc/e4crypt misc/e4defrag misc/filefrag misc/fsck \
	   misc/logsave misc/lsattr misc/mke2fs misc/mklost+found misc/tune2fs misc/uuidd misc/uuidgen \
	   $pkgdir/usr/bin

	mv e2fsck/e2fsck debugfs/debugfs resize/resize2fs  $pkgdir/usr/bin
	
	cd lib
	mv libblkid.a libe2p.a libss.a libuuid.a libcom_err.a libext2fs.a libsupport.a $pkgdir/usr/lib
}

license() {
	cd $pkgname-$pkgver
	cat NOTICE
}
