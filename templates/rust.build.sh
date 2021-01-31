pkgname=
pkgver=

fetch() {
	curl "" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --locked --all-features
}

package() {
	cd $pkgname-$pkgver
	install -Dm 755 target/release/${pkgname} -t "${pkgdir}/usr/bin"
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
