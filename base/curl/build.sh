pkgver=7.77.0
pkg_ver=$(echo $pkgver | tr '.' '_')
pkgname=curl
pkgrel=1
bad=""
ext="doc:dev"

fetch() {
	curl -L "https://github.com/curl/curl/releases/download/curl-$pkg_ver/curl-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	mkdir build
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
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

package_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/bin
	rm $pkgdir/usr/lib/*.so
	rm $pkgdir/usr/lib/*.so.*
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
