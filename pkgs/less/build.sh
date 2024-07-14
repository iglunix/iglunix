pkgname=less
pkgver=633
deps="musl:netbsd-curses"
ext="doc"

ifetch() {
	curl "http://www.greenwoodsoftware.com/less/less-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=$TRIPLE \
		--host=$TRIPLE

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/share
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}

backup() {
	return
}
