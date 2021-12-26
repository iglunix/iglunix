pkgname=openssh
pkgver=8.8p1

fetch() {
	curl "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--libexecdir=/usr/lib

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
	cat LICENCE
}
