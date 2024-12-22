pkgname=dhcpcd
pkgver=10.1.0
mkdeps="bmake"
deps="musl:openssl"

fetch() {
	curl -LO "https://github.com/NetworkConfiguration/dhcpcd/releases/download/v$pkgver/dhcpcd-$pkgver.tar.xz"
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
