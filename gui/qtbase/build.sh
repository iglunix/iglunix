pkgname=qtbase
pkgver=5.15

fetch() {
	curl "https://invent.kde.org/qt/qt/qtbase/-/archive/$pkgver/qtbase-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	mkdir $pkgname-$pkgver/.git
}

build() {
	cd $pkgname-$pkgver
	cd build

	../configure \
		-opensource \
		-confirm-license \
		-nomake examples \
		-nomake tests \
		-platform linux-clang-libc++ \
		-prefix /usr

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	cd build
	bad --gmake gmake INSTALL_ROOT=$pkgdir install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE*
#	cat COPYING
}
