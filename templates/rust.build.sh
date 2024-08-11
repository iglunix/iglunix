pkgname=
pkgver=
comp=
_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl "" -LJo $pkgname-$pkgver.tar.$comp
	tar -xf $pkgname-$pkgver.tar.$comp
	cd $pkgname-$pkgver
	mkdir -p .cargo
	cargo vendor > .cargo/config
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --all-features
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 target/release/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
