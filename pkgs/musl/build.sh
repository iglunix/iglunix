pkgver=1.2.1
pkgname=musl
bad="gmake"
ext="dev"

fetch() {
	curl "https://musl.libc.org/releases/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/ \
		--enable-wrapper=no
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	rm -r $pkgdir/include
	rm $pkgdir/lib/*.a
	rm $pkgdir/lib/*.o
	install -d $pkgdir/usr/bin
	cd $pkgdir/usr/bin
	ln -s ../../lib/ld-musl*.so.? ldd
}

package_dev() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	rm $pkgdir/lib/*.so
	rm $pkgdir/lib/*.so.?
	install -d $pkgdir/usr/
	mv $pkgdir/* $pkgdir/usr/
}

license() {
	cd $pkgname-$pkgver
	cat COPYRIGHT
}
