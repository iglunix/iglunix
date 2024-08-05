pkgname=libepoxy
pkgver=1.5.10

fetch() {
	#curl -L "https://github.com/anholt/libepoxy/releases/download/$pkgver/libepoxy-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	curl -L "https://github.com/anholt/libepoxy/archive/refs/tags/1.5.10.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dglx=no \
		-Dx11=false
	samu
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
