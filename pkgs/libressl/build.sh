pkgver=3.3.1
pkgname=libressl
pkgrel=1
bad=""
ext="doc:dev"

fetch() {
	curl -L "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.3.1.tar.gz" -o $pkgname-$pkgver.tar.gz
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
		-DBUILD_SHARED_LIBS=ON \
		-DOPENSSLDIR=/etc/ssl
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
}

package_doc() {
	samu
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
