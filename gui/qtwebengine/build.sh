pkgname=qtwebengine
pkgver=5.15

_chrome_hash=4e224e5af48f9268d8f72b0f8adf4e9a1a470ca6

fetch() {
	git clone --depth=1 --recursive "https://invent.kde.org/qt/qt/qtwebengine" -b $pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver
	patch -p1 < ../../no-glibc-check.patch
	patch -p1 < ../../qtwebengine-musl.patch
	cd src/3rdparty/
	patch -p1 < ../../../../chromium-musl.patch
}

build() {
	cd $pkgname-$pkgver

	qmake
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake INSTALL_ROOT=$pkgdir install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
