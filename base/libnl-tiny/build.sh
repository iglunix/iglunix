pkgname=libnl-tiny
pkgver=master

fetch() {
	curl -L "https://github.com/sabotage-linux/libnl-tiny/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	gmake prefix=/usr all CC=cc
}

package() {
	cd $pkgname-$pkgver
	gmake prefix=/usr DESTDIR=$pkgdir install
}

license() {
	curl "https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt"
}
