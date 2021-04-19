pkgname=libass
pkgver=0.15.0

fetch() {
	curl -L "https://github.com/libass/libass/releases/download/0.15.0/libass-0.15.0.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
		--disable-asm

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
