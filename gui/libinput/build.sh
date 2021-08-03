pkgname=libinput
pkgver=1.16.4

fetch() {
	curl "https://www.freedesktop.org/software/libinput/libinput-1.16.4.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dlibwacom=false \
		-Ddocumentation=false \
		-Ddebug-gui=false \
		-Dtests=false
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
