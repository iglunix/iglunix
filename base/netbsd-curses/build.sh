pkgver=master
pkgname=netbsd-curses
bad="gmake"
deps="musl"
ext="doc:dev"
auto_cross

fetch() {
	curl -L "https://github.com/sabotage-linux/netbsd-curses/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../cross.patch
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=/usr HOSTCC=cc CROSSCOMPILING=1 LDFLAGS_HOST= CFLAGS_HOST=
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr HOSTCC=cc CROSSCOMPILING=1 LDFLAGS_HOST= CFLAGS_HOST=
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
