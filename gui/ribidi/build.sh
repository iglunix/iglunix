pkgname=ribidi
pkgver=main

fetch() {
	curl -L "https://github.com/iglunix/ribidi/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cargo build --release --all-features
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 target/release/lib$pkgname.so $pkgdir/usr/lib/
	install -Dm644 include/ribidi.h $pkgdir/usr/include/ribidi/
	install -d $pkgdir/usr/include/fribidi
	ln -sr $pkgdir/usr/include/ribidi/ribidi.h $pkgdir/usr/include/fribidi/fribidi.h


	install -Dm644 $pkgname.pc $pkgdir/usr/lib/pkgconfig/
	install -Dm644 f$pkgname.pc $pkgdir/usr/lib/pkgconfig/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
