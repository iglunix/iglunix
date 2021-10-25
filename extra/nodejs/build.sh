pkgname=nodejs
pkgver=16.6.1

fetch() {
	curl -L "https://nodejs.org/dist/v$pkgver/node-v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv node-v$pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver
	sed -i 's/-latomic//' node.gyp
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--shared-zlib \
    	--shared-openssl \
		--with-intl=none \
		--without-etw \
		--without-dtrace \
		--without-report \
		--without-node-snapshot \
		--without-node-code-cache \
		--ninja

    samu -C out/Release
}

package() {
	cd $pkgname-$pkgver

	./tools/install.py install $pkgdir /usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
