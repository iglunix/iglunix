pkgver=2.6.4
pkgname=flex
bad=""
ext="doc"

fetch() {
	curl -L https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/flex $pkgdir/usr/bin/lex
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/lib/*.a
	rm -r $pkgdir/usr/lib/*.la
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
