pkgver=1.2.4
pkgname=python-mako
deps=python
desc="A super-fast templating language"
bad=""
ext="doc"

iifetch() {
	curl -L "https://pypi.io/packages/source/M/Mako/Mako-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv Mako-$pkgver $pkgname-$pkgver
	sed 's|ImportError|ImportError, ModuleNotFoundError|' $pkgname-$pkgver/mako/exceptions.py
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
