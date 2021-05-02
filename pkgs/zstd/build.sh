pkgname=zstd
pkgver=1.4.9

fetch() {
	curl -L "https://github.com/facebook/zstd/releases/download/v1.4.9/zstd-1.4.9.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver

	gmake
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
