pkgname=pfetch
pkgver=0.6.0

fetch() {
	curl -L "https://github.com/dylanaraps/pfetch/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 pfetch /usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}
