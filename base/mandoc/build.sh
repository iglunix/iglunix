pkgname=mandoc
pkgver=1.14.5

fetch() {
	curl "https://mandoc.bsd.lv/snapshots/mandoc-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cp ../configure.local .
	cp ../term-size.patch .
	cp ../man.sh .
	cd $pkgname-$pkgver
	cp ../configure.local .
	patch -p1 < ../term-size.patch
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
	install -Dm644 ./man.sh $pkgdir/etc/profile.d/man.sh
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
