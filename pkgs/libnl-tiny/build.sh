pkgname=libnl-tiny
pkgver=master

fetch() {
	curl "https://git.openwrt.org/?p=project/libnl-tiny.git;a=snapshot;h=HEAD;sf=tgz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../cmake-no-extra-errs.patch .
	mv $pkgname-HEAD-* $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../cmake-no-extra-errs.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	ln -sr $pkgdir/usr/lib/pkgconfig/libnl-tiny.pc $pkgdir/usr/lib/pkgconfig/libnl-3.0.pc
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
