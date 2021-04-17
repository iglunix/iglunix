pkgver=5.11.15
pkgname=linux
pkgrel=1
ext="dev"

fetch() {
	curl "https://raw.githubusercontent.com/kisslinux/website/master/site/dist/kernel-no-perl.patch" -o kernel-no-perl.patch
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
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=lex YACC=yacc LLVM_IAS=1 oldconfig
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=lex YACC=yacc LLVM_IAS=1 menuconfig
	cp .config ../../x86_64.config.new
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=lex YACC=yacc LLVM_IAS=1
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_PATH=$pkgdir/boot install
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_MOD_PATH=$pkgdir/ modules_install
}

package_dev() {
	cd $pkgname-$pkgver
	if stat /usr/bin/rsync 2>/dev/null /dev/null; then
		gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 INSTALL_HDR_PATH=$pkgdir/usr headers_install
	else
		gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 headers
		find -name '.*' -exec rm {} \;
		rm usr/include/Makefile
		cp -r usr/include $pkgdir/usr
	fi
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
