pkgname=openssl
pkgver=1.1.1k

fetch() {
	curl "https://www.openssl.org/source/openssl-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./Configure \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		--libdir=lib \
		linux-$(uname -m) \
		shared no-zlib no-async \
		no-comp no-idea no-mdc2 \
		no-rc5 no-ec2m no-sm2 \
		no-sm4 -no-ssl2 no-ssl3 \
		no-seed no-weak-ssl-ciphers \
		-Wa,--noexecstack

	make
}

package() {
	cd $pkgname-$pkgver
	make install_sw DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
