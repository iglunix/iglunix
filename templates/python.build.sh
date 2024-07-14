pkgname=python-
pkgver=

ifetch() {
	curl "" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	python setup.py build
}

package() {
	cd $pkgname-$pkgver
	python setup.py install --root=$pkgdir --skip-build
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
