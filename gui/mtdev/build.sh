pkgname=mtdev
pkgver=1.1.7
mkdeps=bmake
deps=

ifetch() {
	curl "http://bitmath.org/code/mtdev/mtdev-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$(echo $TRIPLE | sed 's/musl/gnu/g') \
		--host=$(echo $TRIPLE | sed 's/musl/gnu/g')

	make
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
