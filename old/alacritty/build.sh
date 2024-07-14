pkgname=alacritty
pkgver=0.8.0

ifetch() {
	curl -L "https://github.com/alacritty/alacritty/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --no-default-features --features wayland
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE-APACHE
}
