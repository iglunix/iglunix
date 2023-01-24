pkgname=dbus-glib
pkgver=0.112
deps="dbus"

fetch() {
	curl "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=$TRIPLE \
		--host=$TRIPLE

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
	rm -rf $pkgdir/etc
	rm -rf $pkgdir/usr/libexec
	rm -rf $pkgdir/usr/share/gtk-doc
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
