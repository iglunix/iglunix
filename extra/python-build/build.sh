pkgver=1.2.1
pkgname=python-build
deps=python
desc="Tools to build python tools"
bad=""
ext="doc"

fetch() {
	curl -LJ "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv build-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	#export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
	python -m build
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
	pip install --target $pkgdir/usr/lib/python3.12/site-packages/ dist/build-1.2.1-py3-none-any.whl
}

package_doc() {
	echo $pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
