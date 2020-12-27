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
	./configure --prefix=/ --enable-wrapper=no
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/include
	rm $pkgdir/lib/*.a
	rm $pkgdir/lib/*.o
}

package_dev() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm $pkgdir/lib/*.so
	rm $pkgdir/lib/*.so.?
}

license() {
	cd $pkgname-$pkgver
	cat COPYRIGHT
}
