pkgname=piifetch
pkgver=master

iifetch() {
    curl -L "https://github.com/dylanaraps/piifetch/archive/refs/heads/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 piifetch $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}
