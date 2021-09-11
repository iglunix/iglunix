pkgver=1.20210303-1
pkgname=raspberrypi-linux
ext="dev"

fetch() {
	curl "https://raw.githubusercontent.com/kisslinux/website/master/site/dist/kernel-no-perl.patch" -o kernel-no-perl.patch
	curl -L "https://github.com/raspberrypi/linux/archive/refs/tags/raspberrypi-kernel_$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv linux-raspberrypi-kernel_$pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver

	patch -p1 < ../kernel-no-perl.patch
	patch -p1 < ../../kernel-byacc.patch
	# patch -p1 < ../../reflex.patch
}

build() {
	cd $pkgname-$pkgver
	gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 bcm2711_defconfig
	gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	cp arch/arm64/boot/Image $pkgdir/boot/kernel8.img
	gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_PATH=$pkgdir/boot install
	gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_DTBS_PATH=$pkgdir/boot dtbs_install
	gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_MOD_PATH=$pkgdir/ modules_install

	mv $pkgdir/boot/broadcom/* $pkgdir/boot/
	rmdir $pkgdir/boot/broadcom
}

package_dev() {
	cd $pkgname-$pkgver
	if stat /usr/bin/rsync 2>/dev/null /dev/null; then
		gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 INSTALL_HDR_PATH=$pkgdir/usr headers_install
	else
		gmake ARCH=arm64 CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 headers
		find -name '.*' -exec rm {} \;
		rm usr/include/Makefile
		cp -r usr/include $pkgdir/usr
	fi
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
