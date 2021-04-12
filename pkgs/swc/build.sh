pkgname=swc
pkgver=master
deps="wld:pixman"

fetch() {
	curl -L "https://github.com/michaelforney/swc/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config.mk .
}

build() {
	cd $pkgname-$pkgver
	cp ../config.mk .
	
	gmake PREFIX=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
