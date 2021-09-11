pkgname=ncspot
pkgver=0.8.1

_clear_vendor_checksums() {
    	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/hrkfdn/ncspot/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	# curl -L "https://github.com/sfackler/rust-openssl/archive/refs/tags/openssl-v0.10.34.tar.gz" -o rust-openssl.tar.gz
	curl -L "https://github.com/Ella-0/ncurses-rs/archive/refs/heads/master.tar.gz" -o ncurses.tar.gz
	curl -L "https://github.com/Ella-0/pancurses/archive/refs/heads/master.tar.gz" -o pancurses.tar.gz
	tar -xf ncurses.tar.gz
	mv ncurses-rs-master ncurses
	tar -xf pancurses.tar.gz
	mv pancurses-master pancurses
	tar -xf $pkgname-$pkgver.tar.gz
	tar -xf rust-openssl.tar.gz
	cp ../cursive_ptr.patch .
	cd $pkgname-$pkgver
	mkdir -p .cargo
	cargo vendor > .cargo/config
	# _clear_vendor_checksums openssl-sys
	# _clear_vendor_checksums openssl
	_clear_vendor_checksums ncurses
	_clear_vendor_checksums pancurses
	_clear_vendor_checksums cursive
	# cp -r ../rust-openssl-openssl-v0.10.34/openssl/ vendor/
	# cp -r ../rust-openssl-openssl-v0.10.34/openssl-sys/ vendor/
	cp -r ../ncurses/ vendor/
	cp -r ../pancurses/ vendor/
	# sed vendor/openssl/Cargo.toml -i -e 's/0.10.34/0.10.33/g'
	# sed vendor/openssl/Cargo.toml -i -e 's/0.9.62/0.9.61/g'
	# sed vendor/openssl-sys/Cargo.toml -i -e 's/0.9.62/0.9.61/g'
	sed vendor/ncurses/Cargo.toml -i -e 's/5.100.0/5.101.0/g'
	patch -p1 < ../cursive_ptr.patch
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --no-default-features --features cursive/pancurses-backend,alsa_backend
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

