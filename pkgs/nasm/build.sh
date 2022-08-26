pkgname=nasm
pkgver=2.15
pkgrel=1
bad="gmake"
ext="doc"

fetch(){
	curl "https://www.nasm.us/pub/nasm/releasebuilds/$pkgver/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build(){
	cd $pkgname-$pkgver
	./configure \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
		--prefix=/usr
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake DESTDIR="$pkgdir" install
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	bad --gmake gmake DESTDIR="$pkgdir" install
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
