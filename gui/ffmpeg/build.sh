pkgname=ffmpeg
pkgver=4.4

fetch() {
	curl "https://ffmpeg.org/releases/ffmpeg-4.3.2.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--enable-openssl \
		--cc=cc

	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
