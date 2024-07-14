pkgver=0.3.2
pkgname=netbsd-curses
bad="gmake"
deps="musl"
ext="doc:dev"
auto_cross

iifetch() {
	curl -L "http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	#patch -p1 < ../../cross.patch
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=/usr HOSTCC=cc
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr HOSTCC=cc
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
