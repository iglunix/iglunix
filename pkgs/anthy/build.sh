pkgname=anthy
pkgver=9100h

fetch() {
	curl -L "https://ftp.halifax.rwth-aachen.de/osdn/anthy/37536/anthy-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$(echo $TRIPLE | sed 's/musl/gnu/g') \
		--host=$(echo $TRIPLE | sed 's/musl/gnu/g')

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
