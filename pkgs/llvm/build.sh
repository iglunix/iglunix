pkgver=11.0.0
pkgname=llvm
bad=""
ext="libunwind:libunwind-dev:libcxx:libcxx-dev"

fetch() {
	curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv llvm-project-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	mkdir -p build
	cd build
	cmake -G Ninja \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_INSTALL_PREFIX=/ \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_LLD=ON \
		-DLLVM_ENABLE_PROJECTS="libunwind;libcxx;libcxxabi;compiler-rt" \
		-DLLVM_TARGETS_TO_BUILD=X86 \
		-DLIBCXX_ENABLE_FILESYSTEM=ON \
		-DLIBCXX_USE_COMPILER_RT=ON \
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
		../llvm
#		-DLIBCXX_HAS_MUSL_LIBC=ON \
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm $pkgdir/lib/*.a
	rm $pkgdir/lib/libunwind.*
	rm -r $pkgdir/lib/cmake
}

package_libunwind() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install-unwind
	rm $pkgdir/lib/*.a
}

package_libunwind_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install-unwind
	rm $pkgdir/lib/*.so
}

package_libcxx() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install-libcxx
}

package_libcxx_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install-libcxx
}
license() {
	cd $pkgname-$pkgver
	cat */LICENSE.TXT
}
