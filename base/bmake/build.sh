pkgver=20220303
pkgname=bmake
mkdeps=""
deps=""
auto_cross

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
	./configure --prefix=/usr --with-default-sys-path=/usr/share/mk --build=$HOST_TRIPLE --host=$ARCH-linux-musl --with-machine-arch=$ARCH
	MANTARGET=man sh ./make-bootstrap.sh
}

package() {
	cd $pkgname-$pkgver
	./bmake -m ./mk install -f Makefile DESTDIR=$pkgdir MANTARGET=man prefix=/usr/ BINDIR=/usr/bin
	ln -s bmake $pkgdir/usr/bin/make
	rm -rf $pkgdir/usr/share/man/cat1
	install -Dm644 ./bmake.1 $pkgdir/usr/share/man/man1
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
