pkgname=libass
pkgver=0.16.0

iifetch() {
	curl -L "https://github.com/libass/libass/releases/download/$pkgver/libass-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz

	cd $pkgname-$pkgver
	patch -p1 < ../../no-fribidi.patch

	sed -e 's/as_fn_error.*fribidi/: 0 "/' \
		-e '/pkg_requires="fribidi >= .*/d' \
	configure > _
	mv -f _ configure
	chmod +x configure
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--disable-asm

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

backup() {
	return
}
