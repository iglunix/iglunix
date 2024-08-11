pkgver=3.30.2
pkgname=cmake
pkgrel=1
mkdeps="samurai"
deps="musl"
desc="build system"
bad=""
ext=""

fetch() {
	curl -LO "https://github.com/Kitware/CMake/releases/download/v$pkgver/cmake-$pkgver.tar.gz"
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	if [ -z "$WITH_CROSS" ]; then
		printf 'set (CMAKE_USE_OPENSSL OFF CACHE BOOL "Use OpenSSL." FORCE)\n' > init.cmake
		./bootstrap \
			--prefix=/usr \
			--mandir=/share/man \
			--datadir=/share/$pkgname \
			--docdir=/share/doc/$pkgname \
			--generator=Ninja \
			--no-system-libs \
			--init=init.cmake
	else
		mkdir -p build
		cd build
		cmake -G Ninja .. \
			-DCMAKE_INSTALL_PREFIX=/usr \
			-DCMAKE_SYSTEM_NAME=Linux \
			-DCMAKE_SYSROOT=$WITH_CROSS_DIR \
			-DCMAKE_C_COMPILER_TARGET=$TRIPLE \
			-DCMAKE_CXX_COMPILER_TARGET=$TRIPLE \
			-DCMAKE_ASM_COMPILER_TARGET=$TRIPLE \
			-DHAVE_POLL_FINE_EXITCODE=OFF \
			-DHAVE_POLL_FINE_EXITCODE__TRYRUN_OUTPUT=OFF \
			-DCMAKE_PREFIX_PATH=$WITH_CROSS_DIR \
			-DBUILD_CursesDialog=OFF \
			-DCMAKE_USE_OPENSSL=OFF
	fi

	samu
}

package() {
	cd $pkgname-$pkgver
	if [ ! -z "$WITH_CROSS" ]; then
		cd build
	fi
	DESTDIR=$pkgdir samu install

}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat Copyright.txt
}
