pkgname=swc
deps="wld:pixman"
pkgver=intel-tiling

fetch() {
	curl -L "https://github.com/michaelforney/swc/archive/refs/heads/intel-tiling.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config.mk .
}

build() {
	cd $pkgname-$pkgver
	cp ../config.mk .
	
	bad --gmake gmake PREFIX=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
