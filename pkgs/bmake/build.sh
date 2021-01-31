pkgver=20210110
pkgname=bmake
bad="musl"
ext="doc"

fetch() {
	curl http://www.crufty.net/ftp/pub/sjg/bmake-$pkgver.tar.gz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv $pkgname $pkgname-$pkgver
	cd $pkgname-$pkgver
	patch ./boot-strap < ../../no-test.patch
	patch ./install-sh < ../../install.patch
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr --with-default-sys-path=/usr/share/mk
	sh ./make-bootstrap.sh
}

package() {
	cd $pkgname-$pkgver
	./bmake -m ./mk install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/bmake $pkgdir/usr/bin/make
	rm -r $pkgdir/usr/share/man
}

package_doc() {
	cd $pkgname-$pkgver
	./bmake -m ./mk install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/share/mk
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
