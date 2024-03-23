pkgname=wayland-protocols
pkgver=1.34
mkdeps="muon:samurai:pkgconf"
deps="musl:wayland"

fetch() {
	curl -L "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/$pkgver/downloads/wayland-protocols-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	muon setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Ddefault_library=shared \
		-Dtests=false \
		build
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir muon -C build install
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
