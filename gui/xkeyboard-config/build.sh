pkgname=xkeyboard-config
pkgver=2.33

fetch() {
	curl "https://xorg.freedesktop.org/archive/individual/data/$pkgname/$pkgname-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.xz
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

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
