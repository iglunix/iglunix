pkgname=init
pkgver=0.0.1

fetch() {
	curl -L "https://github.com/iglunix/init/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
}

package() {
	cd $pkgname-$pkgver
	cp -r etc $pkgdir
	cp -r lib $pkgdir
	cp -r sbin $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
