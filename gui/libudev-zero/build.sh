pkgname=libudev-zero
pkgver=0.5.2

fetch() {
	curl -L "https://github.com/illiliti/libudev-zero/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	make
	cd contrib
	cc helper.c -o libudev-zero-hotplug-helper
}

package() {
	cd $pkgname-$pkgver
	make install PREFIX=/usr DESTDIR=$pkgdir
	install -d $pkgdir/usr/sbin
	install -Dm755 ./contrib/libudev-zero-hotplug-helper $pkgdir/usr/sbin/
	install -Dm755 ./contrib/helper.sh $pkgdir/usr/sbin/libudev-zero-hotplug-helper.sh
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
