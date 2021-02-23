pkgname=glow
pkgver=1.3.0

fetch() {
	curl -L "https://github.com/charmbracelet/glow/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	go build -o build/
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 build/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
