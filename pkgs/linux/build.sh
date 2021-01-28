pkgver=5.10.11
pkgname=linux
pkgrel=1
ext="dev"

fetch() {
	curl "https://k1ss.org/wiki/kernel/patches/kernel-no-perl.patch" -o kernel-no-perl.patch
	curl "https://cdn.kernel.org/pub/linux/kernel/v5.x/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	patch -p1 < ../kernel-no-perl.patch
	patch -p1 < ../../kernel-byacc.patch
	cp ../../x86_64.config .config
}

build() {
	cd $pkgname-$pkgver
	#gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 defconfig
	#gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 menuconfig
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 oldconfig
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_PATH=$pkgdir/boot install
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_MOD_PATH=$pkgdir/ modules_install
}

package_dev() {
	cd $pkgname-$pkgver
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_HDR_PATH=$pkgdir/usr headers_install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
