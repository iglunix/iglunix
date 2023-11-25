pkgver=2.1.1
pkgname=python-markupsafe
desc="Safely add untrusted strings to HTML/XML markup"
deps=python
bad=""
ext="doc"

fetch() {
	curl -L "https://github.com/pallets/markupsafe/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv markupsafe-$pkgver python-markupsafe-$pkgver
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
	cat LICENSE.rst
}
