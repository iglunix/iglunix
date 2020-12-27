pkgver=0.3.1
pkgname=netbsd-curses
bad=""
ext="doc:dev"

fetch() {
	curl -L https://github.com/sabotage-linux/netbsd-curses/archive/v$pkgver.tar.gz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir PREFIX=/
	rm -r $pkgdir/share
	rm $pkgdir/lib/*.a
	rm -r $pkgdir/include
	rm -r $pkgdir/lib/pkgconfig
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir PREFIX=/
	rm -r $pkgdir/bin
	rm -r $pkgdir/lib
	rm -r $pkgdir/include
}

package_dev() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir PREFIX=/
	rm $pkgdir/lib/*.so
	rm -r $pkgdir/include
	rm -r $pkgdir/share
	rm -r $pkgdir/bin
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
