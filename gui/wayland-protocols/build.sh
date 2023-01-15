pkgname=wayland-protocols
pkgver=1.31
deps="musl:pkgconf:wayland"

fetch() {
	curl -L "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/$pkgver/downloads/wayland-protocols-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
    cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
