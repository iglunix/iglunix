pkgver=2.9.10
pkgname=libxml2
bad=""
ext="dev"

fetch() {
	curl "ftp://xmlsoft.org/libxml2/libxml2-2.9.10.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr --without-python
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

package_dev() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat Copyright
}
