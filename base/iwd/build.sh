pkgname=iwd
pkgver=2.4

iiifetch() {
	curl "https://mirrors.edge.kernel.org/pub/linux/network/wireless/iwd-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--libexecdir=/usr/lib \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--disable-client \
		--disable-systemd-service \
		--disable-dbus-policy

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
