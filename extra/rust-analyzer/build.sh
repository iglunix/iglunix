pkgname=rust-analyzer
pkgver=2024.07.22
_pkgver=2024-07-22
_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/rust-lang/rust-analyzer/archive/refs/tags/$_pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv $pkgname-$_pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver
	mkdir -p .cargo
	cargo vendor > .cargo/config
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked
}

package() {
	cd $pkgname-$pkgver
	mkdir -p $pkgdir/usr/bin/
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE*
}

backup() {
	return
}
