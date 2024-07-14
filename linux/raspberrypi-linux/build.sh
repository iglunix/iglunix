pkgver=1.20211007
pkgname=raspberrypi-linux

ifetch() {
	curl -L "https://github.com/raspberrypi/linux/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv linux-raspberrypi-kernel_$pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver

	patch -p1 < ../../kernel-byacc.patch
	# patch -p1 < ../../reflex.patch
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 bcm2711_defconfig
	bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	cp arch/arm64/boot/Image $pkgdir/boot/kernel8.img
	bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_PATH=$pkgdir/boot install
	bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_DTBS_PATH=$pkgdir/boot dtbs_install
	bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_MOD_PATH=$pkgdir/ modules_install

	mv $pkgdir/boot/broadcom/* $pkgdir/boot/
	rmdir $pkgdir/boot/broadcom

	if stat /usr/bin/rsync 2>/dev/null /dev/null; then
    	echo "using rsync"
		bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_HDR_PATH=$pkgdir/usr headers_install
	else
		bad --gmake gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 headers
		find -name '.*' -exec rm {} \;
		rm usr/include/Makefile
		install -d $pkgdir/usr/
		cp -r usr/include $pkgdir/usr/
	fi
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
