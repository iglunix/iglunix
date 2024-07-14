pkgname=squashfs-tools
pkgver=master

ifetch() {
	curl -L "https://github.com/plougher/squashfs-tools/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cd $pkgname
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	cd $pkgname
	bad --gmake gmake install INSTALL_DIR=$pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
