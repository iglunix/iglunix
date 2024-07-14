pkgver=2.36.2
pkgname=util-linux
pkgrel=1

ifetch() {
	curl "https://mirrors.edge.kernel.org/pub/linux/utils/$pkgname/v2.36/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
		--disable-all-programs \
		--enable-libsmartcols \
		--enable-libuuid \
		--enable-libfdisk \
		--enable-fdisks
		

	make LDFLAGS="-lterminfo"
	
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}


license() {
	cd $pkgname-$pkgver
	cat COPYING
}
