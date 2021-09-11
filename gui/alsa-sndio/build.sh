pkgname=alsa-sndio
pkgver=0.2

fetch() {
	curl -L "https://github.com/Duncaen/alsa-sndio/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	gmake PREFIX=/usr
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir PREFIX=/usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
