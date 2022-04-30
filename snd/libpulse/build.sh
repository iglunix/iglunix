pkgname=libpulse
pkgver=15.99.1

fetch() {
	curl -L "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
	mv pulseaudio-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Ddaemon=false \
		-Dtests=false \
		-Ddoxygen=false \
		-Dclient=true \
		-Dgtk=disabled \
		-Dman=false
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -rf $pkgdir/usr/share/locale
	rm -rf $pkgdir/usr/share/bash*
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
