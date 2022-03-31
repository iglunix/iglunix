pkgver=14.0.0
pkgname=llvm
bad=""
ext="dev"

fetch() {
	curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/llvm-project-$pkgver.src.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv llvm-project-$pkgver.src $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	mkdir -p build
	cd build
        cmake -G Ninja -Wno-dev \
                -DCMAKE_C_COMPILER_TARGET=$TRIPLE \
                -DCMAKE_CXX_COMPILER_TARGET=$TRIPLE \
                -DCMAKE_INSTALL_PREFIX=/usr \
                -DCMAKE_BUILD_TYPE=Release \
                -DLLVM_VERSION_SUFFIX="" \
                -DLLVM_APPEND_VC_REV=OFF \
                -DLLVM_ENABLE_PROJECTS="libunwind;libcxxabi;libcxx;compiler-rt;llvm;lld;clang;clang-tools-extra;lldb" \
                -DLLVM_ENABLE_LLD=ON \
                -DLLVM_TARGETS_TO_BUILD="all" \
                -DLLVM_INSTALL_BINUTILS_SYMLINKS=ON \
                -DLLVM_INSTALL_CCTOOLS_SYMLINKS=ON \
                -DLLVM_INCLUDE_EXAMPLES=OFF \
                -DLLVM_ENABLE_PIC=ON \
                -DLLVM_ENABLE_LTO=OFF \
                -DLLVM_INCLUDE_GO_TESTS=OFF \
                -DLLVM_INCLUDE_TESTS=OFF \
                -DLLVM_HOST_TRIPLE=$TRIPLE \
                -DLLVM_DEFAULT_TARGET_TRIPLE=$TRIPLE \
                -DLLVM_ENABLE_LIBXML2=OFF \
                -DLLVM_ENABLE_ZLIB=OFF\
                -DLLVM_BUILD_LLVM_DYLIB=ON \
                -DLLVM_LINK_LLVM_DYLIB=ON \
                -DLLVM_OPTIMIZED_TABLEGEN=ON \
                -DLLVM_INCLUDE_BENCHMARKS=OFF \
                -DLLVM_INCLUDE_DOCS=ON \
                -DLLVM_TOOL_LLVM_ITANIUM_DEMANGLE_FUZZER_BUILD=OFF \
                -DLLVM_TOOL_LLVM_MC_ASSEMBLE_FUZZER_BUILD=OFF \
                -DLLVM_TOOL_LLVM_MC_DISASSEMBLE_FUZZER_BUILD=OFF \
                -DLLVM_TOOL_LLVM_OPT_FUZZER_BUILD=OFF \
                -DLLVM_TOOL_LLVM_MICROSOFT_DEMANGLE_FUZZER_BUILD=OFF \
                -DLLVM_TOOL_LLVM_GO_BUILD=OFF \
                -DLLVM_INSTALL_UTILS=ON \
                -DLLVM_ENABLE_LIBCXX=ON \
                -DLLVM_STATIC_LINK_CXX_STDLIB=ON \
                -DLLVM_ENABLE_LIBEDIT=OFF \
                -DLLVM_ENABLE_TERMINFO=OFF \
                -DLIBCXX_ENABLE_FILESYSTEM=ON \
                -DLIBCXX_USE_COMPILER_RT=ON \
                -DLIBCXX_HAS_MUSL_LIBC=ON \
                -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
                -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=ON \
                -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
                -DLIBCXX_INSTALL_LIBRARY=ON \
                -DLIBCXXABI_ENABLE_ASSERTIONS=ON \
                -DLIBCXXABI_USE_COMPILER_RT=ON \
                -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
                -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
                -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=YES \
                -DLIBCXXABI_ENABLE_SHARED=OFF \
                -DLIBCXXABI_ENABLE_STATIC=ON \
                -DLIBCXXABI_INSTALL_LIBRARY=ON \
                -DLIBUNWIND_ENABLE_SHARED=ON \
                -DLIBUNWIND_ENABLE_STATIC=ON \
                -DLIBUNWIND_INSTALL_LIBRARY=ON \
                -DLIBUNWIND_USE_COMPILER_RT=ON \
                -DCLANG_DEFAULT_LINKER=lld \
                -DCLANG_DEFAULT_CXX_STDLIB='libc++' \
                -DCLANG_DEFAULT_RTLIB=compiler-rt \
                -DCLANG_DEFAULT_UNWINDLIB=libunwind \
                -DCLANG_VENDOR="Iglunix" \
                -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
                -DCLANG_ENABLE_ARCMT=OFF \
                -DCLANG_LINK_CLANG_DYLIB=OFF \
                -DCOMPILER_RT_USE_BUILTINS_LIBRARY=OFF \
                -DCOMPILER_RT_DEFAULT_TARGET_ONLY=OFF \
                -DCOMPILER_RT_INCLUDE_TESTS=OFF \
                -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
                -DCOMPILER_RT_BUILD_XRAY=OFF \
                -DCOMPILER_RT_BUILD_MEMPROF=OFF \
                -DCOMPILER_RT_INCLUDE_TESTS=OFF \
                -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
                -DENABLE_EXPERIMENTAL_NEW_PASS_MANAGER=TRUE \
                -DCAN_TARGET_i386=1 \
                ../llvm

	samu -j$JOBS
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	ln -s clang $pkgdir/usr/bin/cc
	ln -s clang $pkgdir/usr/bin/c89
	ln -s clang $pkgdir/usr/bin/c99
	ln -s clang++ $pkgdir/usr/bin/c++
	ln -s lld $pkgdir/usr/bin/ld
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
