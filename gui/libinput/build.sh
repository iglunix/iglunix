pkgname=libinput
pkgver=1.19.4
deps="mtdev:libevdev"

fetch() {
	curl "https://www.freedesktop.org/software/libinput/libinput-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
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
