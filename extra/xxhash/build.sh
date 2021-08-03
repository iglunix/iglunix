pkgname=xxhash
pkgver=0.8.0
deps=musl

fetch() {
	curl -L "https://github.com/Cyan4973/xxHash/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv xxHash-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	gmake PREFIX=/usr
}

package() {
	cd $pkgname-$pkgver
	gmake install PREFIX=/usr DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
