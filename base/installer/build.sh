pkgname=installer
pkgver=main

fetch() {
	curl -L "https://github.com/iglunix/installer/archive/refs/heads/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/sbin
	cp installer.sh $pkgdir/usr/sbin/installer
}

license() {
	cd $pkgname-$pkgver
	printf 'Ye naww not yet!'
}

backup() {
	return
}
