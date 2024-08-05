pkgname=iglupkg
pkgver=0.0.3
mkdeps="bmake"
deps="busybox:toybox:mksh:xbps"

fetch() {
	curl -L "https://github.com/iglunix/iglupkg/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	return
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	return
}

backup() {
	return
}
