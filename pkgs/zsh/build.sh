pkgname=zsh
pkgver=5.8

fetch() {
	curl "https://www.zsh.org/pub/zsh-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENCE
#	cat COPYING
}
