pkgname=strace
pkgver=6.1

fetch() {
	curl "https://strace.io/files/$pkgver/strace-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	MAKE=gmake bad --gmake ./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--enable-mpers=no 
	#	--disable-dependency-tracking

	bad --gamke gmake
}

backup() {
}

package() {
	cd $pkgname-$pkgver
	bad --gamke gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}
