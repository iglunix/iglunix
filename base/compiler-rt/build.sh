pkgname=compiler-rt
pkgver=18.1.8
mver=18
deps=linux

fetch() {
	curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/llvm-project-$pkgver.src.tar.xz" -o $pkgname-$pkgver.tar.xz
	# for c++ headers
	# curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/libcxx-$pkgver.src.tar.xz" -o libcxx-$pkgver.tar.xz
	# musl required for C headers
	curl -O "http://musl.libc.org/releases/musl-1.2.5.tar.gz"
	tar -xf $pkgname-$pkgver.tar.xz
	mv llvm-project-$pkgver.src $pkgname-$pkgver
	# tar -xf libcxx-$pkgver.tar.xz
	# mv libcxx-$pkgver.src libcxx-$pkgver
	# cp ../__config_site libcxx-$pkgver/include
	mkdir $pkgname-$pkgver/build
	tar -xf musl-1.2.5.tar.gz
}


build() {
	cd musl-1.2.5
	CFLAGS="--sysroot=/usr/$ARCH-linux-musl --target=$TRIPLE" ./configure --prefix=$(pwd)/../libc --target=$TRIPLE
	bad --gmake gmake install-headers
	cd ..
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../runtimes \
		-DLLVM_ENABLE_RUNTIMES="compiler-rt" \
		-DLLVM_RUNTIME_TARGETS= \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr/lib/clang/$mver/ \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCMAKE_C_COMPILER_TARGET=$TRIPLE \
		-DCMAKE_CXX_COMPILER_TARGET=$TRIPLE \
		-DCMAKE_ASM_COMPILER_TARGET=$TRIPLE \
		-DCMAKE_C_COMPILER_WORKS=ON \
		-DCMAKE_CXX_COMPILER_WORKS=ON \
		-DCMAKE_SYSROOT=/usr/$ARCH-linux-musl \
		-DCMAKE_C_FLAGS_INIT="-I $(pwd)/../../libc/include " \
		-DCMAKE_C_FLAGS="-I $(pwd)/../../libc/include" \
		-DCMAKE_CXX_FLAGS_INIT="-I $(pwd)/../../libc/include" \
		-DCMAKE_CXX_FLAGS="-I $(pwd)/../../libc/include" \
		-DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON \
  		-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=OFF \
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
		-DCAN_TARGET_$ARCH=ON \
		-DCMAKE_SIZEOF_VOID_P=8

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat compiler-rt/LICENSE.TXT
}
