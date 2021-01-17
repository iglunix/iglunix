pkgver=1.2.2
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
		--prefix=/usr \
		--enable-wrapper=no
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	mv $pkgdir/usr/lib/libc.so $pkgdir/lib
	ln -sr $pkgdir/lib/libc.so $pkgdir/lib/ld-musl-x86_64.so.1
	rm -r $pkgdir/usr
	install -d $pkgdir/usr/bin
	ln -sr $pkgdir/lib/ld-musl*.so? $pkgdir/usr/bin/ldd 
}

package_dev() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	rm $pkgdir/usr/lib/*.so
}

license() {
	cd $pkgname-$pkgver
	cat COPYRIGHT
}
