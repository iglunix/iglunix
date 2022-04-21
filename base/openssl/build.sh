pkgname=openssl
pkgver=3.0.0
ext="dev"
auto_cross

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
		linux-generic64 \
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
	install -d $pkgdir/usr/sbin
	install -Dm755 ../../update-ca.sh $pkgdir/usr/sbin/update-ca
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver

	echo 'Copyright 20xx-20yy The OpenSSL Project Authors. All Rights Reserved.'
	echo
	echo 'Licensed under the Apache License 2.0 (the "License").  You may not use'
	echo 'this file except in compliance with the License.  You can obtain a copy'
	echo 'in the file LICENSE in the source distribution or at'
	echo 'https://www.openssl.org/source/license.html'
}
