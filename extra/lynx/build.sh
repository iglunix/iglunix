pkgname=lynx
pkgver=2.8.9

fetch() {
	curl "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv lynx2.8.9rel.1 $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--with-ssl=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
