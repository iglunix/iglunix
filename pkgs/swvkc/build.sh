pkgname=swvkc
pkgver=gpu-dev-option

fetch() {
	curl -L "https://github.com/Ella-0/swvkc/archive/gpu-dev-option.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
