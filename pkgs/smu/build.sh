pkgname=smu
pkgver=master

ifetch() {
	curl -L "https://github.com/Gottox/smu/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config.mk .
}

build() {
	cd $pkgname-$pkgver
	cp ../config.mk .
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
