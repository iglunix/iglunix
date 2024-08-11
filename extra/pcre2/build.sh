pkgname=pcre2
pkgver=10.44

fetch() {
	curl -L "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-$pkgver/pcre2-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

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
