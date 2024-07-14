pkgname=harfbuzz
pkgver=6.0.0
deps="icu"

ifetch() {
	curl -L "https://github.com/harfbuzz/harfbuzz/releases/download/$pkgver/harfbuzz-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	CFLAGS="$CFLAGS -Wunused-but-set-variable" muon setup \
		-Dbuildtype=release \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Ddefault_library=shared \
		-Dglib=disabled \
		-Dgobject=disabled \
		-Dicu=enabled \
		-Dgraphite2=enabled \
		build

	samu -C build
}

backup() {
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir muon -C build install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
