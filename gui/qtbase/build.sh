pkgname=qtbase
pkgver=6.3.1

ifetch() {
	curl "https://invent.kde.org/qt/qt/qtbase/-/archive/$pkgver/qtbase-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	mkdir $pkgname-$pkgver/.git
}

build() {
	cd $pkgname-$pkgver
	cd build

	cmake -G Ninja .. \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DQT_FEATURE_gtk3=OFF

	# ../configure \
	# 	-opensource \
	# 	-confirm-license \
	# 	-nomake examples \
	# 	-nomake tests \
	# 	-platform linux-clang-libc++ \
	# 	-prefix /usr \
	# 	--disable-gtk \
	# 	-no-feature-gtk3
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE*
#	cat COPYING
}

backup() {
	return
}
