pkgname=pixman
pkgver=0.43.4

fetch() {
	curl "https://gitlab.freedesktop.org/pixman/pixman/-/archive/$pkgname-$pkgver/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv pixman-pixman-0.43.4-54cad71674ec485cbbbf49876feaa8a69b97c828 $pkgname-$pkgver 
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--prefix=/usr \
                --buildtype=release \
                --libexecdir=lib

	samu
}

backup() {
    return
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
