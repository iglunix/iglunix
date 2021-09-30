pkgver=3.19.2
pkgname=cmake
pkgrel=1
mkdeps="samu"
deps=""
bad=""
ext=""

fetch() {
	curl "https://cmake.org/files/v3.19/cmake-3.19.2.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./bootstrap \
		--prefix=/usr \
		--mandir=/share/man \
		--datadir=/share/$pkgname \
		--docdir=/share/doc/$pkgname \
		--generator=Ninja \
		--no-system-libs

	samu
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir samu install

}

package_doc() {
	cd $pkgname-$pkgver
	DESDIR=$pkgdir samu install
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/share/info
	rm -r $pkgdir/usr/include
}
package_dev() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/share
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
