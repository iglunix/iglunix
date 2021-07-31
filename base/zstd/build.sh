pkgname=zstd
pkgver=1.5.0

fetch() {
	curl -L "https://github.com/facebook/zstd/releases/download/v$pkgver/zstd-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
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
