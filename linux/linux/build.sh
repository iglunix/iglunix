pkgver=5.13.8
pkgname=linux
pkgrel=1
ext="dev"

fetch() {
	curl "https://raw.githubusercontent.com/kisslinux/website/master/site/dist/kernel-no-perl.patch" -o kernel-no-perl.patch
	curl "https://cdn.kernel.org/pub/linux/kernel/v5.x/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver

	# use Alpine's kernel config so we don't have to maintain one
	curl "https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.$(uname -m)" -o .config
	patch -p1 < ../kernel-no-perl.patch
	patch -p1 < ../../kernel-byacc.patch
	patch -p1 < ../../reflex.patch
}

build() {
	cd $pkgname-$pkgver
	# gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 defconfig
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=reflex YACC=yacc LLVM_IAS=1 olddefconfig
	# gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=lex YACC=yacc LLVM_IAS=1 menuconfig
	# cp .config ../../$(uname -m).config.new
	sed -i 's/CONFIG_UNWINDER_ORC=y/# CONFIG_UNWINDER_ORC is not set/g' .config
	sed -i 's/# CONFIG_UNWINDER_FRAME_POINTER is not set/CONFIG_UNWINDER_FRAME_POINTER=y/g' .config
	gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=reflex YACC=yacc LLVM_IAS=1
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
