pkgname=file
pkgver=5.39
ext="dev:doc"

fetch() {
	curl "ftp://ftp.astron.com/pub/file/file-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm $pkgdir/usr/lib/*.la
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/share/man
	rm -r $pkgdir/usr/lib/pkgconfig
}

package_dev() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/lib
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/share/misc
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
