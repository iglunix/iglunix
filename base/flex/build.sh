pkgname=flex
pkgver=2.6.4
auto_cross

fetch() {
	curl -L "https://github.com/westes/flex/releases/download/v2.6.4/flex-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	[ -z "$WITH_CROSS" ] || extra_flags=--disable-bootstrap

	MAKE=gmake bad --gmake ./configure \
		--prefix=/usr \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE \
		$extra_flags

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/flex $pkgdir/usr/bin/lex
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
