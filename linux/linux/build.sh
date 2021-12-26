pkgver=5.15
pkgname=linux
pkgrel=1
ext="dev"

fetch() {
    return
	# curl "https://raw.githubusercontent.com/kisslinux/website/master/site/dist/kernel-no-perl.patch" -o kernel-no-perl.patch
	curl "https://cdn.kernel.org/pub/linux/kernel/v5.x/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver

	# use Alpine's kernel config so we don't have to maintain one
	# curl "https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.$(uname -m)" -o .config
	# patch -p1 < ../kernel-no-perl.patch
	patch -p1 < ../../kernel-byacc.patch
	patch -p1 < ../../v3d-enable.patch
	# patch -p1 < ../../reflex.patch
}

_arch=$ARCH
case $_arch in
aarch64*) _arch="arm64" ;;
esac

build() {
	cd $pkgname-$pkgver
	return
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch defconfig
	bad --gmake gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ YACC=yacc LLVM_IAS=1 ARCH=$_arch localmodconfig
	# gmake CC=cc CXX=c++ HOSTCC=cc HOSTCXX=c++ LEX=lex YACC=yacc LLVM_IAS=1 menuconfig
	# cp .config ../../$(uname -m).config.new
	sed -i 's/CONFIG_UNWINDER_ORC=y/# CONFIG_UNWINDER_ORC is not set/g' .config
	sed -i 's/# CONFIG_UNWINDER_FRAME_POINTER is not set/CONFIG_UNWINDER_FRAME_POINTER=y/g' .config
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
