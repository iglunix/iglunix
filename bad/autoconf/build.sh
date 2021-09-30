pkgname=autoconf
pkgver=2.13

fetch() {
	curl "https://ftp.gnu.org/gnu/autoconf/autoconf-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../makefile-m4f.patch
	patch -p1 < ../../autoconf.sh.patch
	patch -p1 < ../../autoheader.sh.patch
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr/bad/autoconf/ \
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
	cat COPYING
}
