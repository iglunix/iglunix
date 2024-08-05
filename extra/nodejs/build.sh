pkgname=nodejs
pkgver=20.15.0

fetch() {
	curl -L "https://nodejs.org/dist/v$pkgver/node-v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv node-v$pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver
	sed -i 's/-latomic//' node.gyp
	patch -p1 < ../../no-bz2.patch
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--shared-zlib \
		--shared-openssl \
		--with-intl=none \
		--without-report \
		--without-node-snapshot \
		--without-node-code-cache \
		--ninja


	samu -C out/Release
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver

	./tools/install.py install --dest-dir $pkgdir --prefix /usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
