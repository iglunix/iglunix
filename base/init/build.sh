pkgname=init
pkgver=main

fetch() {
	curl -L "https://github.com/iglunix/init/archive/refs/heads/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	cp -r etc $pkgdir
	cp -r lib $pkgdir
	cp -r sbin $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
