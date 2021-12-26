pkgname=harfbuzz
pkgver=3.0.0

fetch() {
	curl -L "https://github.com/harfbuzz/harfbuzz/releases/download/$pkgver/harfbuzz-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	CFLAGS="$CFLAGS -Wunused-but-set-variable" meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dglib=disabled \
		-Dgobject=disabled \
		-Dicu=enabled

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
