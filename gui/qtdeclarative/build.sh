pkgname=qtdeclarative
pkgver=5.15

fetch() {
	curl "https://invent.kde.org/qt/qt/$pkgname/-/archive/$pkgver/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/.git
}

build() {
	cd $pkgname-$pkgver

	qmake
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake INSTALL_ROOT=$pkgdir install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
