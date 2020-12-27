pkgver=0.8.4
pkgname=toybox
pkgrel=1

fetch() {
	curl "http://www.landley.net/toybox/downloads/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make defconfig
	make
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm755 ./toybox $pkgdir/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
