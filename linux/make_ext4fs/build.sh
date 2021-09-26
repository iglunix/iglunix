pkgname=make_ext4fs
pkgver=main

fetch() {
	curl -L "https://github.com/iglunix/make_ext4fs/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/sbin
	install -Dm755 ./make_ext4fs $pkgdir/sbin/mkfs.ext4
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
