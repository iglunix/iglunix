pkgname=mpv
pkgver=0.34.1

ifetch() {
	curl -L "https://github.com/mpv-player/mpv/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./bootstrap.py
	./waf configure --prefix=/usr --confdir=/etc/mpv --enable-libmpv-shared

	./waf build
}

package() {
	cd $pkgname-$pkgver
	./waf install --destdir=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat Copyright
	cat LICENSE.*
#	cat COPYING
}

backup() {
	return
}
