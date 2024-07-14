pkgname=zig
pkgver=0.8.0

iifetch() {
	curl "https://ziglang.org/download/$pkgver/zig-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cp ../llvm-req-arch.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../llvm-req-arch.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -rf $pkgdir/usr/lib/zig/libc/glibc
	rm -rf $pkgdir/usr/lib/zig/libc/mingw
	rm -rf $pkgdir/usr/lib/zig/libc/wasi

	rm -rf $pkgdir/usr/lib/zig/libc/include/*gnu*
	rm -rf $pkgdir/usr/lib/zig/libc/include/*glibc*
	rm -rf $pkgdir/usr/lib/zig/libc/include/*windows*
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
