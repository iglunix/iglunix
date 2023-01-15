pkgname=pixman
pkgver=master

fetch() {
	curl "https://gitlab.freedesktop.org/pixman/pixman/-/archive/master/pixman-master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
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
