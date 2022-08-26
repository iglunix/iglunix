pkgname=fakeroot
pkgver=1.26

fetch() {
	curl "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_$pkgver.orig.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	patch -p1 < ../../no64.patch
	patch -p1 < ../../stdint.patch
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
