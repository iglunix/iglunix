pkgver=0.3.2
pkgname=netbsd-curses
subpkgs="netbsd-curses"
bad="gmake"
deps="musl"
ext="doc:dev"

fetch() {
	curl -L "http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=/usr HOSTCC=cc
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr HOSTCC=cc
}

netbsd-curses() {
	shlibs="libcurses.so libterminfo.so libmenu.so libpanel.so"
	find *
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
