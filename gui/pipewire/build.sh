pkgname=pipewire
pkgver=0.3.27

fetch() {
	curl "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/$pkgver/pipewire-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build

	cp ../no-dbus.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../no-dbus.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dbluez5=disabled \
		-Dlibcamera=disabled \
		-Dexamples=disabled \
		-Dgstreamer=disabled \
		-Dlibpulse=disabled \
		-Dmedia-session=enabled \
		-Dpw-cat=enabled
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
