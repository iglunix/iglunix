pkgver=16.0.1
pkgname=libunwind
mkdeps=openssl:cmake:samurai
bad=""
ext="dev"

fetch() {
	curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/llvm-project-$pkgver.src.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv llvm-project-$pkgver.src $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

	PREFIX=/usr

	[ -z "$FOR_CROSS" ] || PREFIX=$FOR_CROSS_DIR

	if [ ! -z "$WITH_CROSS" ]; then
		cmake_extra_flags=-DCMAKE_SYSROOT=$WITH_CROSS_DIR
	fi

	mkdir -p build
	cd build
	cmake -G Ninja -Wno-dev \
		-DLLVM_ENABLE_RUNTIMES="libunwind" \
		-DLIBUNWIND_USE_COMPILER_RT=ON \
		-DLIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG=1 \
		-DLIBCXXABI_USE_LLVM_UNWINDER=YES \
		-DLIBCXX_HAS_MUSL_LIBC=ON \
		-DCMAKE_ASM_COMPILER=$CC \
		-DCMAKE_C_COMPILER=$CC \
		-DCMAKE_CXX_COMPILER=$CXX \
		-DCMAKE_ASM_COMPILER_TARGET=$ARCH-linux-musl \
		-DCMAKE_C_COMPILER_TARGET=$ARCH-linux-musl \
		-DCMAKE_CXX_COMPILER_TARGET=$ARCH-linux-musl \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_ASM_FLAGS="$CFLAGS" \
		-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS -unwindlib=none" \
		$cmake_extra_flags \
		-DCMAKE_INSTALL_PREFIX=$PREFIX \
		-DCMAKE_C_COMPILER_WORKS=1 \
		-DCMAKE_CXX_COMPILER_WORKS=1 \
		-DCMAKE_SKIP_BUILD_RPATH=0 \
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=1 \
		-DCMAKE_INSTALL_RPATH='${ORIGIN}/../lib' \
		../runtimes

	samu -j$JOBS
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

package_dev() {
	echo "No... Shut"
}

license() {
	cd $pkgname-$pkgver
	cat */LICENSE.TXT
}
