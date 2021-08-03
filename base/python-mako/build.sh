pkgver=1.1.4
pkgname=python-mako
deps=python
bad=""
ext="doc"

fetch() {
	curl -L "https://pypi.io/packages/source/M/Mako/Mako-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv Mako-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	python setup.py build
}

package() {
	cd $pkgname-$pkgver
	python setup.py install --prefix=/usr --root=$pkgdir
}

package_doc() {
	echo $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
