pkgname=basu
pkgver=0.2.0

ifetch() {
	curl "https://git.sr.ht/~emersion/basu/refs/download/v$pkgver/basu-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../../0001-remove-gperf.patch
	patch -p1 < ../../bus-error.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		--libdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE*
}

backup() {
	return
}
