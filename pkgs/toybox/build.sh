pkgver=0.8.4
pkgname=toybox
pkgrel=1
deps="musl:pci-ids"

fetch() {
	curl "http://www.landley.net/toybox/downloads/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../mksh-make.patch
}

build() {
	cd $pkgname-$pkgver
	gmake defconfig
	gmake
}

package() {
	cd $pkgname-$pkgver
#	install -d $pkgdir/bin
#	install -Dm755 ./toybox $pkgdir/bin/
#	ln -sr $pkgdir/bin/toybox $pkgdir/bin/ln
#	ln -sr $pkgdir/bin/toybox $pkgdir/bin/uname
#	install -d $pkgdir/usr/bin
#	ln -sr $pkgdir/bin/toybox $pkgdir/usr/bin/install
#	ln -sr $pkgdir/bin/toybox $pkgdir/usr/bin/lspci
	gmake PREFIX=$pkgdir install

	rm $pkgidr/usr/bin/clear
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
