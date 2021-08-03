pkgver=2021.04.07
pkgname=youtube-dl
deps=python
bad=""

fetch() {
	curl -L "https://github.com/ytdl-org/youtube-dl/releases/download/2021.04.07/youtube-dl-2021.04.07.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv $pkgname $pkgname-$pkgver
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
