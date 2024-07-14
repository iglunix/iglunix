pkgname=i3status-rust
pkgver=0.21.2

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

ifetch() {
	curl -L "https://github.com/greshake/i3status-rust/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
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
	install -Dm755 target/release/i3status-rs $pkgdir/usr/bin/i3status-rs
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
