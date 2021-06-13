pkgname=bin86
pkgver=0.16.21

fetch() {
	curl "https://sources.archlinux.org/other/community/dev86/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	curl -L "https://github.com/ataraxialinux/ataraxia/raw/master/stuff/bin86/bin86-0.16.17-x86_64-1.patch" | patch -p1
}

build() {
	cd $pkgname-$pkgver
	gmake PREFIX=/usr
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -d $pkgdir/usr/share/man/man1
	gmake PREFIX=$pkgdir/usr MANDIR=$pkgdir/usr/share/man/man1 install
}

license() {
	cd $pkgname-$pkgver
	cat README
}
