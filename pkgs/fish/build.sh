pkgver=3.1.2
pkgname=fish
pkgrel=1

fetch() {
	curl -L "https://github.com/fish-shell/fish-shell/releases/download/3.1.2/fish-3.1.2.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../output_tputs_cast.patch
}

build() {
	cd $pkgname-$pkgver
	mkdir build
	cd build
	cmake -G Ninja .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_EXE_LINKER_FLAGS=-lterminfo \
		-DCMAKE_INSTALL_PREFIX='/usr'
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR="$pkgdir/" samu install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
