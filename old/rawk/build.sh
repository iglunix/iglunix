pkgname=rawk
pkgver=master

ifetch() {
	curl -L "https://github.com/kisom/rawk/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../cp-u.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../cp-u.patch
}

build() {
	cd $pkgname-$pkgver
	PREFIX=/usr ./config.sh
	make
}

package() {
	cd $pkgname-$pkgver
	make install PREFIX=$pkgdir/usr/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
