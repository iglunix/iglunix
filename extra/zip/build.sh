pkgname=zip
pkgver=30

fetch() {
	curl "https://fossies.org/linux/misc/zip$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv zip$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

	make -f unix/Makefile generic
}

package() {
	cd $pkgname-$pkgver
	make -f unix/Makefile install prefix=$pkgdir/usr
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
