pkgname=rsync
pkgver=3.2.3

ifetch() {
	curl "https://download.samba.org/pub/rsync/src/rsync-3.2.3.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl \
                --disable-xxhash \
                --disable-zstd \
                --disable-lz4

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
