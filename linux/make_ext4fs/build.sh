pkgname=make_ext4fs
pkgver=0.0.1
mkdeps=toybox:bmake:llvm
deps=musl:zlib-ng
auto_cross

fetch() {
	curl -L "https://github.com/iglunix/make_ext4fs/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
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

backup() {
	return
}
