pkgname=harfbuzz
pkgver=2.7.4

fetch() {
	curl -L "https://github.com/harfbuzz/harfbuzz/releases/download/2.7.4/harfbuzz-2.7.4.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
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
