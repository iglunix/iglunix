pkgname=tbb
pkgver=master

fetch() {
	curl -L "https://github.com/oneapi-src/oneTBB/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv oneTBB-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../../musl-malloc-proxy.patch
	patch -p1 < ../../musl-rtld.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DTBB_TEST=OFF \
		-DCMAKE_CXX_FLAGS=-Wno-unused-command-line-argument
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.txt
#	cat COPYING
}
