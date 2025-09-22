pkgname=noto
pkgver=2025.09.01
subpkgs=noto

fetch() {
	curl -L "https://github.com/notofonts/notofonts.github.io/archive/refs/tags/noto-monthly-release-$pkgver.tar.gz" -o noto-$pkgver.tar.gz
	tar -xf noto-$pkgver.tar.gz
	mv notofonts.github.io-noto-monthly-release-$pkgver noto-$pkgver
}

build() {
	:
}

package() {
	cd $pkgname-$pkgver
	mkdir -p "$pkgdir/usr/share/fonts/noto"
	cp fonts/*/hinted/ttf/*.tt[fc] "$pkgdir/usr/share/fonts/noto"
}

noto() {
	find .
}

license() {
	:
}
