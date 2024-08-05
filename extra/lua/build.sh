pkgname=lua
pkgver=5.4.7

fetch() {
	curl "http://www.lua.org/ftp/lua-$pkgver.tar.gz" -LJo $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make all CC=cc
}

package() {
	cd $pkgname-$pkgver
	make install INSTALL_TOP=$pkgdir/usr
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat ../../LICENSE
#	cat COPYING
}
