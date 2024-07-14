pkgname=wayland
pkgver=1.23.0
mkdeps=muon:samurai:pkgconf:python
deps=libffi:expat

ifetch() {
	curl -L "https://gitlab.freedesktop.org/wayland/wayland/-/releases/$pkgver/downloads/wayland-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	meson setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Ddefault_library=shared \
		-Dlibraries=true \
		-Dscanner=true \
		-Dtests=false \
		-Ddocumentation=false \
		-Ddtd_validation=false \
		build
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir meson install -C build
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
