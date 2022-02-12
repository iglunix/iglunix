pkgver=7.81.0
pkg_ver=$(echo $pkgver | tr '.' '_')
pkgname=curl
pkgrel=1
mkdeps="samu:cmake"
deps="openssl"
bad=""

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
		-DCURL_CA_BUNDLE="/etc/ssl/cert.pem"
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
