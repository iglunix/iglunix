pkgname=muon
pkgver=0.2.0
mkdeps=samurai
deps=pkgconf
desc="meson implementation in C"

iifetch() {
	curl -L "https://git.sr.ht/~lattis/muon/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./bootstrap.sh build
	./build/muon setup \
		-D prefix=/usr \
		-D libcurl=disabled \
		-D libarchive=disabled \
		-D libpkgconf=enabled \
		-D samurai=disabled \
		-D bestline=enabled \
		build

	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir build/muon -C build install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSES/GPL-3.0-only.txt
}

backup() {
	return
}
