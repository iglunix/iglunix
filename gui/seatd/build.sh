pkgname=seatd
pkgver=0.7.0
mkdeps=samurai:muon:pkgconf
deps=musl

fetch() {
	curl "https://git.sr.ht/~kennylevinsen/seatd/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	muon setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Dexamples=disabled \
		-Dc_args=-Wno-sign-compare \
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

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
