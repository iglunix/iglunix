pkgname=bat
pkgver=0.17.1

fetch() {
	curl -L "https://github.com/sharkdp/bat/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --all-features
}

package() {
	cd $pkgname-$pkgver
	install -Dm 755 target/release/${pkgname} "${pkgdir}/usr/bin/"
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE-MIT
}
