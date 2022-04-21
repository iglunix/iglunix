pkgname=zlib-ng
pkgver=2.0.5

fetch() {
	curl -L "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build

	PREFIX=/usr

	[ -z "$WITH_CROSS" ] || cmake_extra_flags="-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_SYSROOT=$WITH_CROSS_DIR \
		-DCMAKE_C_COMPILER_TARGET=$ARCH-linux-musl"
	[ -z "$FOR_CROSS" ] || PREFIX=$FOR_CROSS_DIR

	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$PREFIX \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DZLIB_COMPAT=ON \
		$cmake_extra_flags

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}

backup() {
	return
}
