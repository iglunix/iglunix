pkgname=zig
pkgver=master

fetch() {
	curl -L "https://github.com/ziglang/zig/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.gz
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
