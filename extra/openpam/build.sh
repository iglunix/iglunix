pkgname=openpam
pkgver=20190224

fetch() {
	curl -LO "https://openpam.des.dev/downloads/openpam-$pkgver.tar.gz"
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
