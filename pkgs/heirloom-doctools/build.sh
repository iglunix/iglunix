pkgver=master
pkgname=heirloom-doctools
pkgrel=1
deps="musl"
bad="gmake"
ext="doc"

fetch() {
	curl -L "https://github.com/n-t-roff/heirloom-doctools/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	cp ../../mk.config .
}

build() {
	cd $pkgname-$pkgver
	./configure
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install ROOT=$pkgdir
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	gmake install ROOT=$pkgdir
	rm -r $pkgdir/usr/lib
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
