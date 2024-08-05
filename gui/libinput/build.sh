pkgname=libinput
pkgver=1.26.1
mkdeps="samurai:muon:pkgconf"
deps="mtdev:libevdev:libudev-zero"

fetch() {
	curl "https://gitlab.freedesktop.org/libinput/libinput/-/archive/$pkgver/libinput-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	muon setup \
		-Dbuildtype=release \
		-Ddefault_library=shared \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Dlibwacom=false \
		-Ddocumentation=false \
		-Ddebug-gui=false \
		-Dtests=false \
		build
	samu -C build
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir muon -C build install
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
