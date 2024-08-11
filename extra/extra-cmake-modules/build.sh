pkgname=extra-cmake-modules
_ver_maj_min=6.4
pkgver=$_ver_maj_min.0

fetch() {
	curl -L "https://download.kde.org/stable/frameworks/$_ver_maj_min/extra-cmake-modules-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
<<<<<<< HEAD
	cat LICENSE
#	cat COPYING
=======
	cat COPYING-CMAKE-SCRIPTS
}

backup() {
	return
>>>>>>> 9e054eb (fix rebase fail)
}
