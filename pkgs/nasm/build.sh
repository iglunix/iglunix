pkgname=nasm
pkgver=2.15
pkgrel=1
bad="gmake"

fetch(){
	curl "https://www.nasm.us/pub/nasm/releasebuilds/$pkgver/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build(){
	cd $pkgname-$pkgver
	./configure \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl
		--prefix=/usr
	gmake
}

package(){
	cd $pkgname-$pkgver
	gmake DESTDIR="$pkgdir" install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
