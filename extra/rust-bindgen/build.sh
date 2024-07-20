pkgname=rust-bindgen
pkgver=0.69.4

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
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
	install -Ddm755 target/release/bindgen $pkgdir/usr/bin/bindgen
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
