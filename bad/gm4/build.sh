pkgname=gm4
pkgver=1.4.19

fetch() {
	curl "http://ftp.gnu.org/pub/gnu/m4/m4-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv m4-$pkgver gm4-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--program-prefix=g \
		--host=$TRIPLE \
		--disable-nls

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
