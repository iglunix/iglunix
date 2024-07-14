pkgname=alsa-lib
pkgver=1.2.7.2

iifetch() {
	curl -L "http://www.alsa-project.org/files/pub/lib/alsa-lib-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

backup() {
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
