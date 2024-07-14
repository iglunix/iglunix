pkgname=libevdev
pkgver=1.13.2
mkdeps="samurai:muon:pkgconf:python"

iifetch() {
	curl "https://www.freedesktop.org/software/libevdev/libevdev-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
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
