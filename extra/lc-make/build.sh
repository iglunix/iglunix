pkgname=lc-make
pkgver=main
mkdeps="rust"
deps=""

fetch() {
	curl -L "https://github.com/LightningCreations/lc-make/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	mkdir .cargo
	cargo vendor > .cargo/config
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --all-features
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
