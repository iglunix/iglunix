pkgname=glow
pkgver=1.5.1

fetch() {
	curl -L "https://github.com/charmbracelet/glow/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	go build -o build/
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
}
