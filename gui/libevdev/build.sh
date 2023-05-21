pkgname=libevdev
pkgver=1.13.1
mkdeps="samurai:muon:pkgconf"

fetch() {
	curl "https://www.freedesktop.org/software/libevdev/libevdev-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	muon setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Dtests=disabled \
		-Ddocumentation=disabled \
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
	cat COPYING
}
