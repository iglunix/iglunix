pkgname=yasm
pkgver=1.3.0

fetch() {
	curl -L "https://github.com/yasm/yasm/releases/download/v$pkgver/yasm-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		# --build=$TRIPLE \
		# --host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
