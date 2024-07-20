pkgname=rust-analyzer
pkgver=2024.07.15
pkver=2024-07-15

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/rust-lang/rust-analyzer/archive/refs/tags/$pkver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkver
	mkdir -p .cargo
	cargo vendor > .cargo/config
}

build() {
	cd $pkgname-$pkver
	cargo build --release --locked
}

package() {
	cd $pkgname-$pkver
	mkdir -p $pkgdir/usr/bin/
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkver
	cat LICENSE*
}

backup() {
	return
}
