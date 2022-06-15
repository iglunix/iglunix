pkgname=linux
pkgrel=1
ext="dev"

# setting the KERNEL_TREE environment variable changes the source
# location and updates the pkgver accordingly
#
# currently the following valuse for KERNEL_TREE are supported:
#  - mainline - latest stable linux kernel release with alpine's config
#
#  - asahi - latest asahi kernel from git with config taken form their PKGBUILD
#    repo
#
#  - rpi - latest raspberry pi kernel release with defconfig
#
#  - visionfive - latest starfive-tech kernel from the vision five branch with
#    visionfive_defconfig
#
#  - megi - latest megi kernel with pinephone_pro_defconfig
#
# TODO:
# add KERNEL_CONFIG option to override config used when compiling

if [ -z "$KERNEL_TREE" ]; then
	KERNEL_TREE=mainline
fi

case "$KERNEL_TREE" in
	mainline)
		pkgver=5.17.3
		src_tar="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$pkgver.tar.xz"
		fetch_config="https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.$(uname -m)"
		config=olddefconfig
		;;
	asahi)
		pkgver=asahi
		src_tar="https://github.com/AsahiLinux/linux/archive/refs/heads/asahi.tar.gz"
		fetch_config="https://raw.githubusercontent.com/AsahiLinux/PKGBUILDs/main/linux-asahi/config"
		config=olddefconfig
		;;
	visionfive)
		pkgver=visionfive
		src_tar="https://github.com/starfive-tech/linux/archive/refs/heads/visionfive.tar.gz"
		config=visionfive_defconfig
		;;
	*)
		fatal "KERNEL_TREE $KERNEL_TREE isn't supported yet"
		;;
esac

fetch() {
	curl -L "$src_tar" -o $pkgname-$pkgver.tar
	tar -xf $pkgname-$pkgver.tar

	# use Alpine's kernel config so we don't have to maintain one
	[ ! -z "$fetch_config" ] && curl "$fetch_config" -o .config
	cd $pkgname-$pkgver
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

if [ ! -z "$FOR_CROSS" ]; then
	export HEADS_ONLY=1
fi


build() {
	cd $pkgname-$pkgver
	[ ! -z "$fetch_config" ] && cp ../.config .
	bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch "$config"

	# sed -i 's/CONFIG_UNWINDER_ORC=y/# CONFIG_UNWINDER_ORC is not set/g' .config
	# sed -i 's/# CONFIG_UNWINDER_FRAME_POINTER is not set/CONFIG_UNWINDER_FRAME_POINTER=y/g' .config

	if [ -z "$HEADS_ONLY" ]; then
		bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch
	fi
}

package() {
	cd $pkgname-$pkgver

	if [ -z "$HEADS_ONLY" ]; then
		install -d $pkgdir/boot
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_PATH=$pkgdir/boot install
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_DTBS_PATH=$pkgdir/boot/dtbs dtbs_install

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
		install -d $pkgdir/$FOR_CROSS_DIR/
		cp -r usr/include $pkgdir/$FOR_CROSS_DIR/
	fi
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
