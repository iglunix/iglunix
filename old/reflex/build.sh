pkgname=reflex
pkgver=20210510

ifetch() {
	curl "https://invisible-island.net/datafiles/release/reflex.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir

	ln -sr $pkgdir/usr/bin/reflex $pkgdir/usr/bin/lex
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
