pkgver=18.1.8
pkgname=libcxx
deps="musl"
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
	[ -z "$WITH_CROSS" ] || cmake_extra_flags=-DCMAKE_SYSROOT=$WITH_CROSS_DIR

	mkdir -p build
	cd build
	cmake -G Ninja -Wno-dev \
		-DLLVM_ENABLE_RUNTIMES="libunwind;libcxx;libcxxabi" \
		-DLIBCXX_ENABLE_FILESYSTEM=ON \
		-DLIBCXX_USE_COMPILER_RT=ON \
		-DLIBCXX_HAS_MUSL_LIBC=ON \
		-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
		-DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=ON \
		-DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
		-DLIBCXXABI_ENABLE_ASSERTIONS=ON \
		-DLIBCXXABI_USE_COMPILER_RT=ON \
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON \
		-DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
		-DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=YES \
		-DLIBCXXABI_ENABLE_SHARED=ON \
		-DLIBCXXABI_ENABLE_STATIC=ON \
		-DLIBUNWIND_ENABLE_SHARED=ON \
		-DLIBUNWIND_ENABLE_STATIC=ON \
		-DLIBUNWIND_USE_COMPILER_RT=ON \
		-DCMAKE_C_COMPILER=$CC \
		-DCMAKE_CXX_COMPILER=$CXX \
		-DCMAKE_C_COMPILER_TARGET=$ARCH-linux-musl \
		-DCMAKE_CXX_COMPILER_TARGET=$ARCH-linux-musl \
		-DCMAKE_C_FLAGS="$CFLAGS -fPIC" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS -fPIC" \
		$cmake_extra_flags \
		-DCMAKE_INSTALL_PREFIX=$PREFIX \
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
