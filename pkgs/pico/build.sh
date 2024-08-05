pkgname=pico
pkgver=2.00

fetch() {
	curl "http://ftp.swin.edu.au/alpine/alpine-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
	mv alpine-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--without-ldap \
		--without-ssl \
		--without-krb5

	make -s c-client
	make -s c-client.d
	make -s -C pith
	make -s -C pico
}

package() {
	cd $pkgname-$pkgver
	install -d /usr/bin
	install -Dm755 ./pico/pico $pkgdir/usr/bin/
	install -Dm755 ./pico/pilot $pkgdir/usr/bin/
	ln -sr $pkgdir/usr/bin/pico $pkgdir/usr/bin/nano
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
