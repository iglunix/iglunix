pkgver=master
pkgname=kati
pkgrel=1

fetch() {
	curl -LL "https://github.com/google/kati/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm755 ./ckati $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
