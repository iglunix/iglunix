pkgver=4.3
pkgname=gmake
pkgrel=1
deps="musl"
bad="gmake"
ext="doc:dev"
auto_cross

iiifetch() {
	curl "https://ftp.gnu.org/gnu/make/make-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv make-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr/bad/gmake \
		--program-prefix=g \
		--disable-nls \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bad/gmake/share
	rm -r $pkgdir/usr/bad/gmake/include
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESDIR=$pkgdir
	rm -r $pkgdir/usr/bad/gmake/bin
	rm -r $pkgdir/usr/bad/gmake/share/info
	rm -r $pkgdir/usr/bad/gmake/include
}
package_dev() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bad/gmake/bin
	rm -r $pkgdir/usr/bad/gmake/share
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
