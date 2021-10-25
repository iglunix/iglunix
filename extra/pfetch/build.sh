pkgname=pfetch
pkgver=master

fetch() {
    curl -L "https://github.com/dylanaraps/pfetch/archive/refs/heads/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 pfetch $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}
