pkgname=libglvnd
pkgver=master

fetch() {
	curl -L "https://github.com/NVIDIA/libglvnd/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		--libdir=lib \
		-Dtls=false
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	tail -n 20 README.md
#	cat COPYING
}

backup() {
	return
}
