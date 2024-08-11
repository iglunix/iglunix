pkgver=71.1.0
pkgname=python-setuptools
deps=python
desc="Tools to build python tools"
bad=""
ext="doc"

fetch() {
	curl -LJ "https://github.com/pypa/setuptools/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv setuptools-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
	python setup.py build
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
	python setup.py install --prefix=/usr --root=$pkgdir
}

package_doc() {
	echo $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
