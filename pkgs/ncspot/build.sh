pkgname=ncspot
pkgver=0.6.0

_clear_vendor_checksums() {
    	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/hrkfdn/ncspot/archive/refs/tags/v0.6.0.tar.gz" -o $pkgname-$pkgver.tar.gz
	curl -L "https://github.com/sfackler/rust-openssl/archive/refs/tags/openssl-v0.10.34.tar.gz" -o rust-openssl.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	tar -xf rust-openssl.tar.gz
	cd $pkgname-$pkgver
	mkdir -p .cargo
	cargo vendor > .cargo/config
	_clear_vendor_checksums openssl-sys
	_clear_vendor_checksums openssl
	cp -r ../rust-openssl-openssl-v0.10.34/openssl/ vendor/
	cp -r ../rust-openssl-openssl-v0.10.34/openssl-sys/ vendor/
	sed vendor/openssl/Cargo.toml -i -e 's/0.10.34/0.10.33/g'
	sed vendor/openssl/Cargo.toml -i -e 's/0.9.62/0.9.61/g'
	sed vendor/openssl-sys/Cargo.toml -i -e 's/0.9.62/0.9.61/g'
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --no-default-features --features termion_backend,alsa_backend
}

package() {
	cd $pkgname-$pkgver
	install -Dm 755 target/release/$pkgname $pkgdir/usr/bin/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

