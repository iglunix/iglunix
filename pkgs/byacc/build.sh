pkgver=20200910
pkgname=byacc
bad=""
ext="doc"

fetch() {
	curl https://invisible-island.net/datafiles/release/byacc.tar.gz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/ \
		--program-prefix=b \
		--enable-btyacc
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	cd $pkgdir/bin
	ln -s byacc yacc
	rm -r $pkgdir/share
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/bin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
