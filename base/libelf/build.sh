pkgname=libelf
pkgver=0.186

fetch() {
	curl -LO "https://sourceware.org/elfutils/ftp/$pkgver/elfutils-$pkgver.tar.bz2"
	tar -xf elfutils-$pkgver.tar.bz2
	cd elfutils-$pkgver
	patch -p1 < ../../musl.patch
}

build() {
	cd elfutils-$pkgver
	export CFLAGS="$(CFLAGS) -Wno-error"
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--disable-symbol-versioning \
		--disable-debuginfod \
		--disable-libdebuginfod \
		--disable-nls \
		ac_cv_c99=yes

	bad --gmake gmake -C lib
	bad --gmake gmake -C libelf
}

package() {
	cd elfutils-$pkgver
	bad --gmake gmake -C libelf install DESTDIR=$pkgdir
}

backup() {
	return
}

license() {
	return
}
