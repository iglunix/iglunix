pkgver=8.8.0
pkg_ver=$(echo $pkgver | tr '.' '_')
pkgname=curl
pkgrel=1
mkdeps="bmake"
deps="openssl"
bad=""
auto_cross

fetch() {
	curl -L "https://github.com/curl/curl/releases/download/curl-$pkg_ver/curl-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE \
		--disable-symvers \
		--with-openssl \
		--with-ca-bundle=/etc/ssl/cert.pem
	make
}

package() {
	cd $pkgname-$pkgver
	make DESTDIR=$pkgdir install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
