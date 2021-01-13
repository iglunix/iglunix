pkgver=1.1.0
pkgname=pkgconf
bad=""
ext="doc"

fetch() {
	curl https://distfiles.dereferenced.org/pkgconf/pkgconf-1.1.0.tar.xz -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/pkgconf $pkgdir/usr/bin/pkg-config
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
