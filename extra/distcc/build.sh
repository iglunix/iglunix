pkgname=distcc
pkgver=3.3.5
bad="gmake"

fetch() {
	curl -L "https://github.com/distcc/distcc/releases/download/v$pkgver/distcc-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
		--without-libiberty

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

	install -d $pkgdir/usr/lib/distcc

	ln -s ../../../usr/bin/distcc $pkgdir/usr/lib/distcc/cc
	ln -s ../../../usr/bin/distcc $pkgdir/usr/lib/distcc/c89
	ln -s ../../../usr/bin/distcc $pkgdir/usr/lib/distcc/c99
	ln -s ../../../usr/bin/distcc $pkgdir/usr/lib/distcc/c++
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
