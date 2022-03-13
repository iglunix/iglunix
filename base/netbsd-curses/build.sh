pkgver=master
pkgname=netbsd-curses
bad="gmake"
deps="musl"
ext="doc:dev"

fetch() {
	curl -L "https://github.com/sabotage-linux/netbsd-curses/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=/usr
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
