pkgname=glib
pkgver=2.80.4

fetch() {
	curl -L "https://gitlab.gnome.org/gnome/glib/-/archive/$pkgver/glib-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
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
		-Dnls=disabled \
		-Dwerror=false \
		-Dwarning_level=0
	samu
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install

	rm -rf $pkgdir/usr/share/bash-completion
	rm -rf $pkgdir/usr/share/gdb

	rm -rf $pkgdir/usr/bin/gdbus
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
