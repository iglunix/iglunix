pkgname=graphicsmagick
pkgver=1.3.36

fetch() {
	curl "http://ftp.icm.edu.pl/pub/unix/graphics/GraphicsMagick/GraphicsMagick-LATEST.tar.zst" -o $pkgname-$pkgver.tar.zst
	tar -I zstd -xf $pkgname-$pkgver.tar.zst
	mv GraphicsMagick-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir

	ln -s ../usr/bin/gm $pkgdir/usr/bin/animate
	ln -s ../usr/bin/gm $pkgdir/usr/bin/compare
	ln -s ../usr/bin/gm $pkgdir/usr/bin/composite
	ln -s ../usr/bin/gm $pkgdir/usr/bin/conjure
	ln -s ../usr/bin/gm $pkgdir/usr/bin/convert
	ln -s ../usr/bin/gm $pkgdir/usr/bin/display
	ln -s ../usr/bin/gm $pkgdir/usr/bin/identify
	ln -s ../usr/bin/gm $pkgdir/usr/bin/import
	ln -s ../usr/bin/gm $pkgdir/usr/bin/mogrify
	ln -s ../usr/bin/gm $pkgdir/usr/bin/montage
}

license() {
	cd $pkgname-$pkgver
	cat Copyright.txt
}
