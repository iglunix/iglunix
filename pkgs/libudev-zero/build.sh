pkgname=libudev-zero
pkgver=0.4.7

fetch() {
	curl -L "https://github.com/illiliti/libudev-zero/archive/0.4.7.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	make
}

package() {
	cd $pkgname-$pkgver
	make install PREFIX=/usr DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
