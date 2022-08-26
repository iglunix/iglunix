pkgname=toolchain-aarch64
pkgver=12.0.0

fetch() {
	curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/llvm-project-$pkgver.src.tar.xz" -o llvm-$pkgver.tar.gz
	curl "https://musl.libc.org/releases/musl-1.2.2.tar.gz" -o musl-1.2.2.tar.gz
	tar -xf llvm-$pkgver.tar.gz
	tar -xf musl-1.2.2.tar.gz
	mv llvm-project-$pkgver.src llvm-$pkgver
	mkdir llvm-$pkgver/build-compiler-rt
	mkdir sysroot
}

build() {
	export pkgdir=$(pwd)/sysroot
	cd llvm-$pkgver
	cd build-compiler-rt
	cmake -G Ninja ../compiler-rt \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr/aarch64-linux-musl \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_C_COMPILER_TARGET=aarch64-linux-musl \
		-DCMAKE_ASM_COMPILER=clang \
		-DCMAKE_ASM_COMPILER_TARGET=aarch64-linux-musl \
		-DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON \
		-DCOMPILER_RT_BUILD_BUILTINS=ON \
		-DCOMPILER_RT_DEFAULT_TARGET_ONLY=OFF \
		-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=aarch64-linux-musl \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF \
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
		-DCOMPILER_RT_BUILD_XRAY=OFF \
		-DCOMPILER_RT_BUILD_MEMPROF=OFF \
		-DCOMPILER_RT_BUILD_PROFILE=OFF \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF \
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
		-DCMAKE_C_FLAGS='-nostdlib' \
		-DCMAKE_ASM_FLAGS='-nostdlib' \
		-DCAN_TARGET_aarch64=YES \
		-DLIBCXX_HAS_MUSL_LIBC=ON \
		-DLLVM_CONFIG_PATH=/usr/bin/llvm-config

	DESTDIR=$pkgdir samu install
	cd ../..

	cd musl-1.2.2
	CFLAGS="--sysroot=$pkgdir/usr/aarch64-linux-musl/ --target=aarch64-unknown-linux-musl" AR=ar LIBCC=$pkgdir/usr/aarch64-linux-musl/lib/linux/libclang_rt.builtins-aarch64.a ./configure \
		--prefix=/usr/aarch64-linux-musl \
		--target=aarch64-unknown-linux-musl \
		--enable-wrappers=no

	bad --gmake gmake
	bad --gmake gmake install DESTDIR=$pkgdir
}

package() {
	mv sysroot/* $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
