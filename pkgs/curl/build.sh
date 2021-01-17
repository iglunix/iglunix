pkgver=7.74.0
pkgname=curl
pkgrel=1
bad=""
ext="doc:dev"

fetch() {
	curl -L "https://github.com/curl/curl/releases/download/curl-7_74_0/curl-7.74.0.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	mkdir build
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
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
	rm -r $pkgdir/usr/lib/cmake
}

package_doc() {
	samu
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
