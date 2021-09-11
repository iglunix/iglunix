pkgname=lua
pkgver=5.4.3

fetch() {
	curl "http://www.lua.org/ftp/lua-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	make CC=cc
}

package() {
	cd $pkgname-$pkgver
	make install INSTALL_TOP=$pkgdir/usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
