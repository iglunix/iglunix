pkgver=1.2.2
pkgname=musl
deps=""
bad="gmake"
ext="dev"

fetch() {
	curl "https://musl.libc.org/releases/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
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
	rm -r $pkgdir/usr/include
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
