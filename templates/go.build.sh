pkgname=
pkgver=
comp=

fetch() {
	curl "" -LJo $pkgname-$pkgver.tar.$comp
	tar -xf $pkgname-$pkgver.tar.$comp
}

build() {
	cd $pkgname-$pkgver
	go build -o build
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 build/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
