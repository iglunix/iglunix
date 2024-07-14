pkgver=1.2.11
pkgname=zlib
bad=""
ext="dev"

ifetch() {
	curl https://zlib.net/zlib-1.2.11.tar.xz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
    echo "============="
    echo " DEPRECATED: "
    echo " USE ZLIB-NG "
    echo "============="

	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm $pkgdir/usr/lib/*.a
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
	rm -r $pkgdir/usr/share
}

package_dev() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
	rm $pkgdir/usr/lib/*.so
	rm $pkgdir/usr/lib/*.so.*
	rm -r $pkgdir/usr/share
}

license() {
	cd $pkgname-$pkgver
	grep -A 24 '^  Copyright' zlib.h
}
