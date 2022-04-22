pkgname=zstd
pkgver=1.5.2
auto_cross

fetch() {
	curl -L "https://github.com/facebook/zstd/releases/download/v$pkgver/zstd-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install PREFIX=/usr DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
