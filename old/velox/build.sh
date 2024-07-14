pkgname=velox
pkgver=master

ifetch() {
	curl -L "https://github.com/michaelforney/velox/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config.mk .
	cp ../velox.conf .
}

build() {
	cd $pkgname-$pkgver
	cp ../config.mk .
	cp ../velox.conf .
	
	bad --gmake gmake PREFIX=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
	install -d $pkgdir/etc
	install -Dm644 velox.conf $pkgdir/etc/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
