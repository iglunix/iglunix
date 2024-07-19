pkgver=18.1.8
pkgname=libgcc
mkdeps="openssl:cmake:samurai:python"
deps=
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
		-DLLVM_ENABLE_RUNTIMES="llvm-libgcc" \
		-DLIBUNWIND_USE_COMPILER_RT=ON \
		-DLIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG=1 \
		-DDEFAULT_COMPILER_RT_BUILTINS_LIBRARY=ON \
		-DCOMPILER_RT_USE_LLVM_UNWINDER=ON \
		-DCOMPILER_RT_CXX_LIBRARY=libcxx \
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
		-DLLVM_LIBGCC_EXPLICIT_OPT_IN=Yes \
		-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
		$cmake_extra_flags \
		-DCOMPILER_RT_USE_LLVM_UNWINDER=ON \
		-DCOMPILER_RT_CXX_LIBRARY=libcxx \
		-DCOMPILER_RT_DEFAULT_TARGET_ONLY=OFF \
		-DCOMPILER_RT_INCLUDE_TESTS=ON \
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
		-DCOMPILER_RT_BUILD_XRAY=OFF \
		-DCOMPILER_RT_BUILD_MEMPROF=OFF \
		-DCOMPILER_RT_BUILD_ORC=OFF \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF \
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
		-DCOMPILER_RT_DEFAULT_TARGET_ONLY=OFF \
		-DCOMPILER_RT_BUILD_PROFILE=OFF \
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
