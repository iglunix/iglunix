pkgname=mpv
pkgver=0.33.1

fetch() {
	curl -L "https://github.com/mpv-player/mpv/archive/refs/tags/v0.33.1.tar.gz" -o $pkgname-$pkgver.tar.xz
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
	cat LICENSE
#	cat COPYING
}
