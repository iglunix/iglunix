pkgname=wld
pkgver=master
deps="fontconfig"

fetch() {
	curl -L "https://github.com/michaelforney/wld/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=/usr CC=cc
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
