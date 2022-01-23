pkgname=autossh
pkgver=1.4g

fetch() {
	curl "https://www.harding.motd.ca/autossh/autossh-$pkgver.tgz" -LO
	tar -xf $pkgname-$pkgver.tgz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
