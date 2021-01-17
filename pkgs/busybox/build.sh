pkgver=1.33.0
pkgname=busybox
bad=gmake
pkgrel=1

fetch() {
	curl "https://busybox.net/downloads/busybox-1.33.0.tar.bz2" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	gmake HOSTCC=cc CC=cc CFLAGS=-O0 defconfig
	gmake HOSTCC=cc CC=cc CFLAGS=-O0
	gmake HOSTCC=cc CC=cc CFLAGS=-O0 install
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir
	cp -r ./_install/* $pkgdir
	chmod 4755 $pkgdir/bin/busybox
	rm $pkgdir/linuxrc
	rm $pkgdir/bin/ln
	rm $pkgdir/bin/uname
	rm $pkgdir/usr/bin/install
	rm $pkgdir/usr/bin/lspci
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
