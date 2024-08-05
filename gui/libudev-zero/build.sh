pkgname=libudev-zero
pkgver=1.0.3
pkgrel=1
mkdeps=bmake

fetch() {
	curl -L "https://github.com/illiliti/libudev-zero/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	CFLAGS="$CFLAGS -fPIC" make
	cd contrib
	cc helper.c -fPIC -o libudev-zero-hotplug-helper
}

package() {
	cd $pkgname-$pkgver
	make install PREFIX=/usr DESTDIR=$pkgdir
	install -d $pkgdir/usr/sbin
	install -Dm755 ./contrib/libudev-zero-hotplug-helper $pkgdir/usr/sbin/
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
