pkgname=kbd
pkgver=2.4.0

ifetch() {
	curl "https://mirrors.edge.kernel.org/pub/linux/utils/kbd/kbd-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	curl "https://raw.githubusercontent.com/workman-layout/Workman/master/linux_console/workman.iso15.kmap" -o workman.map
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
		--disable-tests \
		--sysconfdir=/etc

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	install -d $pkgdir/usr/share/keymaps/i386/workman/
	install -Dm 644 ../workman.map $pkgdir/usr/share/keymaps/i386/workman/
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
