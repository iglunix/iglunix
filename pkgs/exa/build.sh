pkgname=exa
pkgver=0.9.0

fetch() {
	curl -L "https://github.com/ogham/exa/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	ln -s /usr/bin/gmake make
}

build() {
	cd $pkgname-$pkgver
	PATH=$(pwd)"/..:$PATH" cargo build --release --locked --all-features
}

package() {
	cd $pkgname-$pkgver
	cd target/release
	install -Dm755 "$pkgname" "$pkgdir/usr/bin/"
}

license() {
	cd $pkgname-$pkgver
	cat LICENCE
}
