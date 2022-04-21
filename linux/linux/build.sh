pkgver=5.17.3
pkgname=linux
pkgrel=1
ext="dev"

fetch() {
	curl "https://cdn.kernel.org/pub/linux/kernel/v5.x/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	# use Alpine's kernel config so we don't have to maintain one
	curl "https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.$(uname -m)" -o .config
}

_arch=$ARCH
case $_arch in
aarch64*) _arch="arm64" ;;
riscv64*) _arch="riscv" ;;
ppc64le*) _arch="powerpc" ;;
esac

if [ ! -z "$WITH_CROSS" ]; then
	export CROSS_COMPILE=$WITH_CROSS-linux-musl
fi


build() {
	cd $pkgname-$pkgver
	bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch olddefconfig
	sed -i 's/CONFIG_UNWINDER_ORC=y/# CONFIG_UNWINDER_ORC is not set/g' .config
	sed -i 's/# CONFIG_UNWINDER_FRAME_POINTER is not set/CONFIG_UNWINDER_FRAME_POINTER=y/g' .config

	if [ -z "$FOR_CROSS" ]; then
		bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch
	fi
}

package() {
	cd $pkgname-$pkgver

	if [ -z "$FOR_CROSS" ]; then
		install -d $pkgdir/boot
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_PATH=$pkgdir/boot install
		set +e # depmod causes errors
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_MOD_PATH=$pkgdir/ modules_install
		set -e
	fi

	bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch headers
	find -name '.*' -exec rm {} \;
	rm -f usr/include/Makefile
	if [ -z "$FOR_CROSS" ]; then
		install -d $pkgdir/usr/
		cp -r usr/include $pkgdir/usr/
	else
		install -d $pkgdir/usr/$FOR_CROSS_DIR
		cp -r usr/include $pkgdir/$FOR_CROSS_DIR
	fi
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
