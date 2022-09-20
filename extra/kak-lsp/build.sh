pkgname=kak-lsp
pkgver=14.0.0

fetch() {
	curl -L "https://github.com/kak-lsp/kak-lsp/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --all-features
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/
	install -Dm644 rc/lsp.kak $pkgdir/usr/share/kak-lsp/rc/
	install -Dm644 kak-lsp.toml $pkgdir/usr/share/kak-lsp/examples/
}

license() {
	cd $pkgname-$pkgver
	cat UNLICENSE
}

backup() {
	return
}
