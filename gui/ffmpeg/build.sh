pkgname=ffmpeg
pkgver=7.0.1
pkgrel=1

fetch() {
	curl "https://ffmpeg.org/releases/ffmpeg-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	CFLAGS="$CFLAGS -Wno-incompatible-pointer-types -Wno-implicit-const-int-float-conversion -fPIC" \
	./configure \
		--prefix=/usr \
		--enable-openssl \
		--cc=cc

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
#	cat COPYING
}

backup() {
	return
}
