pkgname=iglupkg
pkgver=0.0.1
mkdeps="bmake"

fetch() {
	curl -L "https://github.com/iglunix/iglupkg/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	return
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	return
}

backup() {
	return
}
