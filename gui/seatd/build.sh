pkgname=seatd
pkgver=0.8.0
pkgrel=1
mkdeps=samurai:meson:pkgconf
deps=musl

fetch() {
	curl "https://git.sr.ht/~kennylevinsen/seatd/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	meson setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Dlibseat-builtin=enabled \
		-Dlibseat-seatd=enabled \
		-Dlibseat-logind=disabled \
		-Dexamples=disabled \
		-Dc_args="-Wno-sign-compare -fPIC" \
		build
	samu -C build
}

backup() {
	return
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
	cat LICENSE
#	cat COPYING
}
