pkgname=patchelf
pkgver=0.12

ifetch() {
	curl -L "https://github.com/NixOS/patchelf/releases/download/0.12/patchelf-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
	mv $pkgname-$pkgver*/ $pkgname-$pkgver
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

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
