pkgname=dhcpcd
pkgver=9.4.1

fetch() {
	curl -LO "https://roy.marples.name/downloads/dhcpcd/dhcpcd-$pkgver.tar.xz"
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--libexecdir=/usr/lib \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
