pkgname=libnl-tiny
pkgver=master

fetch() {
	curl -L "https://github.com/sabotage-linux/libnl-tiny/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	ckati prefix=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	ckati install prefix=/usr DESTDIR=$pkgdir CC=cc
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
