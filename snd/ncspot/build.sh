pkgname=ncspot
pkgver=1.1.1

_clear_vendor_checksums() {
    	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl -L "https://github.com/hrkfdn/ncspot/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	mkdir -p .cargo
	cargo vendor > .cargo/config
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --no-default-features --features cursive/termion-backend,pulseaudio_backend
}

package() {
	cd $pkgname-$pkgver
	mkdir -p $pkgdir/usr/bin/
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
