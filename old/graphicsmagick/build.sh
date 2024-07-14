pkgname=graphicsmagick
pkgver=1.3.36

ifetch() {
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
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/animate
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/compare
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/composite
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/conjure
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/convert
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/display
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/identify
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/import
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/mogrify
	ln -sr $pkgdir/usr/bin/gm $pkgdir/usr/bin/montage
	
}

license() {
	cd $pkgname-$pkgver
	cat Copyright.txt
}
