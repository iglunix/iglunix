pkgname=github-cli
pkgver=1.6.2

fetch() {
	curl -L "https://github.com/cli/cli/archive/v1.6.2.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv cli-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	ckati
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 bin/gh $pkgdir/usr/bin/gh
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
