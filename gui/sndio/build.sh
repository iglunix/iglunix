pkgname=sndio
pkgver=1.9.0

fetch() {
	curl -L "https://sndio.org/sndio-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--enable-alsa

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

}

backup() {
	return
}

license() {
	cd ../
	cat LICENSE
#	cat COPYING
}
