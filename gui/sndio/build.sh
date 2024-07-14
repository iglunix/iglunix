pkgname=sndio
pkgver=1.8.1
ext="dev:doc"

iifetch() {
	curl -L "https://sndio.org/sndio-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--enable-alsa

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

	rm -rf $pkgdir/usr/share/man

	rm -rf $pkgdir/usr/include
	rm -rf $pkgdir/usr/lib/pkgconfig
}

package_dev() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

	rm -rf $pkgdir/usr/bin
	rm -rf $pkgdir/usr/share/man
	rm -rf $pkgdir/usr/lib/*.so*
}

package_doc() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

	rm -rf $pkgdir/usr/lib
	rm -rf $pkgdir/usr/bin
	rm -rf $pkgdir/usr/include
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
