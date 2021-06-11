pkgver=1.2.2
pkgname=musl
deps=""
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
		--build=$(uname -m)-unknown-linux-musl \
		--host=$(uname -m)-unknown-linux-musl \
		--enable-wrapper=no
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/include
	install -d $pkgdir/usr/bin
	ln -sr $pkgdir/lib/ld-musl-$(uname -m).so.1 $pkgdir/usr/bin/ldd
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
