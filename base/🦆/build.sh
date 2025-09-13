pkgname=🦆
subpkgs=🦆
pkgver=1.0.0
desc="Quack!"

fetch() {
	curl -L "https://github.com/iglunix/duck/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv duck-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

🦆() {
	find usr/bin/🦆
}

license() {
	return
}

backup() {
	return
}
