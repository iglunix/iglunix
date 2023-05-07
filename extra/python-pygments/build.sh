pkgver=2.14.0
pkgname=python-pygments
deps=python
bad=""
ext="doc"

fetch() {
	curl -L "https://github.com/pygments/pygments/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv pygments-$pkgver python-pygments-$pkgver
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
	python setup.py install --prefix=/usr --root=$pkgdir
}

package_doc() {
	echo $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
