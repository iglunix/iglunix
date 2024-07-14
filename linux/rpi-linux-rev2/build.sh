pkgver=rpi-5.10.y
pkgname=linux
pkgrel=1
ext="dev"

ifetch() {
    ifetch_tar "$pkgname-$pkgver.tar.gz" f633fabf55892cf19fc9173d2b8df779 "https://github.com/raspberrypi/linux/archive/refs/heads/$pkgver.tar.gz"
	cd $pkgname-$pkgver

	patch -p1 < ../../kernel-byacc.patch
	curl 'https://cgit.freedesktop.org/drm/drm/patch/?id=26a4dc29b74a137f45665089f6d3d633fcc9b662' | patch -p1
}

_arch=$ARCH
case $_arch in
aarch64*) _arch="arm64" ;;
esac

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch bcm2711_defconfig
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch INSTALL_PATH=$pkgdir/boot install
	bad --gmake gmake CC=cc HOSTCC=cc LEX=flex YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_DTBS_PATH=$pkgdir/boot dtbs_install
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch INSTALL_MOD_PATH=$pkgdir/ modules_install

	if stat /usr/bin/rsync 2>/dev/null /dev/null; then
		bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch INSTALL_HDR_PATH=$pkgdir/usr headers_install
	else
		bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch headers
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
