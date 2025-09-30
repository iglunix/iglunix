pkgname=libedit
subpkgs="libedit libedit-dev"
pkgver=20250104-3.1

fetch() {
	curl -LO "https://thrysoee.dk/editline/libedit-$pkgver.tar.gz"
	tar -xf "libedit-$pkgver.tar.gz"
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \

	make
}

package() {
	cd $pkgname-$pkgver
	make DESTDIR=$pkgdir install
}

libedit() {
	shlibs="libedit.so.0"
	find usr/lib/*.so.*
}

libedit-dev() {
	find usr/lib/*.so
	find usr/lib/pkgconfig
	find usr/include
}

