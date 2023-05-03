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
#
# ----------
#
# If the user uses `iglu del`on this pkg, the pkg can NOT be rebuilt!
# to fix this `../../../usr/bin/iglupkg --with-cross=x86_64 --with-cross-dir=/iglunix --for-cross --for-cross-dir=/usr fbp` from an external linux can be used

if [ -z "$KERNEL_TREE" ]; then
	KERNEL_TREE=mainline
fi

case "$KERNEL_TREE" in
	mainline)
		pkgver=6.1.21
		# Only for torvalds tree
		# src_tar="https://git.kernel.org/torvalds/t/linux-$pkgver.tar.gz"

		# LTS
		src_tar="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$pkgver.tar.xz"
		# temporarily disabled to reduce ci time
		# fetch_config="https://src.fedoraproject.org/rpms/kernel/raw/rawhide/f/kernel-$ARCH-fedora.config"
		# config=olddefconfig
		config=defconfig
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
	echo "#!/bin/true" > scripts/check-local-export
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

	grep -v 'select HAVE_OBJTOOL' arch/x86/Kconfig > _
	mv _ arch/x86/Kconfig

	bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch "$config"

	# nicer install name
	./scripts/config -d CONFIG_LOCALVERSION
	./scripts/config -d CONFIG_LOCALVERSION_AUTO

	# Known bad config options
	./scripts/config -d CONFIG_IKHEADERS
	./scripts/config -d CONFIG_SPEAKUP
	./scripts/config -d CONFIG_DEBUG_INFO_BTF

	# This tries to tell clang to target thumbv8a-linux-gnuabi for aarch64
	# We do not build this by default in iglunix-bootstrap.
	./scripts/config -d CONFIG_COMPAT_VDSO
	./scripts/config -d CONFIG_THUMB2_COMPAT_VDSO

	# Warnings exist ;~;
	./scripts/config -d CONFIG_WERROR

	# Need for booting
	./scripts/config -e CONFIG_EFI_STUB

	# Enable simple framebuffer only output.
	# Note: no fbdev drivers.
	./scripts/config -e CONFIG_FB
	# ensure DRM is not a module.
	./scripts/config -e CONFIG_DRM
	./scripts/config -e CONFIG_SYSFB_SIMPLEFB
	./scripts/config -e CONFIG_DRM_SIMPLEDRM

	# Building with objtool requires libelf and that's utter pain
	./scripts/config -d CONFIG_HAVE_OBJTOOL
	./scripts/config -d CONFIG_OBJTOOL
	./scripts/config -d CONFIG_FTRACE
	./scripts/config -d CONFIG_UNWINDER_ORC
	./scripts/config -d CONFIG_STACK_VALIDATION
	./scripts/config -e CONFIG_UNWINDER_FRAME_POINTER

	# Bake in important modules to allow booting without initramfs
	./scripts/config -e CONFIG_BLK_DEV_NVME
	./scripts/config -e CONFIG_NVME_CORE
	./scripts/config -e CONFIG_EXT4_FS

	bad --gmake gmake CC=clang HOSTCC=clang YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch "olddefconfig"

	cat .config >&2

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

		set +e # depmod causes errors and not all configs have dtbs
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_DTBS_PATH=$pkgdir/boot/dtbs dtbs_install
		bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch INSTALL_MOD_PATH=$pkgdir/ modules_install
		set -e
	fi

	bad --gmake gmake CC=cc HOSTCC=cc YACC=yacc LLVM=1 LLVM_IAS=1 ARCH=$_arch headers

	if [ -z "$FOR_CROSS" ]; then
		install -d $pkgdir/usr/
		cp -r usr/include $pkgdir/usr/
		find $pkgdir/usr/include -type f ! -name '*.h' -delete
	else
		install -d $pkgdir/$FOR_CROSS_DIR/
		cp -r usr/include $pkgdir/$FOR_CROSS_DIR/
		find $pkgdir/$FOR_CROSS_DIR/ -type f ! -name '*.h' -delete
	fi
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
