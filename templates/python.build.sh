pkgname=python-
pkgver=
comp=

fetch() {
	curl "" -LJo $pkgname-$pkgver.tar.$comp
	tar -xf $pkgname-$pkgver.tar.$comp
}

build() {
	cd $pkgname-$pkgver
	python setup.py build
}

backup() {
	return
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
