pkgname=velox
pkgver=master

fetch() {
	curl -L "https://github.com/michaelforney/velox/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config.mk .
	cp ../velox.conf .
}

build() {
	cd $pkgname-$pkgver
	cp ../config.mk .
	cp ../velox.conf .
	
	gmake PREFIX=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir PREFIX=/usr
	install -d $pkgdir/etc
	install -Dm644 velox.conf $pkgdir/etc/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
