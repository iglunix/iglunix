pkgname=glib
_pkgver=2.68
pkgver=$_pkgver.4

fetch() {
	curl -L "https://download.gnome.org/sources/glib/$_pkgver/glib-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
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
		-Dtests=false \
		-Dnls=disabled
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install

	rm -rf $pkgdir/usr/share/bash-completion
	rm -rf $pkgdir/usr/share/gdb

	rm -rf $pkgdir/usr/bin/gdbus*
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
