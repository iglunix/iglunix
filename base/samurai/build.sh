pkgver=1.2
pkgname=samurai
desc="ninja-compatible build tool written in C"
pkgrel=1
deps="musl"
auto_cross

fetch() {
	curl -L "http://github.com/michaelforney/samurai/releases/download/1.2/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make LDFLAGS="$LDFLAGS"
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm755 ./samu $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}

backup() {
	return
}
