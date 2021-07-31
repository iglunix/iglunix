pkgver=master
pkgname=netbsd-curses
bad=""
deps="musl"
ext="doc:dev"

fetch() {
	curl -L "https://github.com/sabotage-linux/netbsd-curses/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	ckati
}

package() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir PREFIX=/usr
	rm -r $pkgdir/usr/share
	rm $pkgdir/usr/lib/*.a
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
}

package_doc() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir PREFIX=/usr
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/lib
	rm -r $pkgdir/usr/include
}

package_dev() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir PREFIX=/usr
	rm $pkgdir/usr/lib/*.so
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
