pkgver=0.60.2
pkgname=meson
deps=python
bad=""

fetch() {
	curl -L "https://github.com/mesonbuild/meson/releases/download/$pkgver/meson-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cp ../not-darwin.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../not-darwin.patch
}

build() {
	cd $pkgname-$pkgver
	python setup.py build
}

package() {
	cd $pkgname-$pkgver
	python setup.py install --prefix=/usr --root=$pkgdir
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
