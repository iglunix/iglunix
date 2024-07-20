pkgname=ribidi
pkgver=0.0.1
pkver=main

fetch() {
	curl -L "https://github.com/iglunix/ribidi/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkver
	cargo build --release
}

package() {
	cd $pkgname-$pkver
	mkdir -p $pkgdir/usr/lib/pkgconfig $pkgdir/usr/include/ribidi
	install -Dm755 target/release/lib$pkgname.so $pkgdir/usr/lib/
	install -Dm644 include/ribidi.h $pkgdir/usr/include/ribidi/
	install -d $pkgdir/usr/include/fribidi
	ln -sr $pkgdir/usr/include/ribidi/ribidi.h $pkgdir/usr/include/fribidi/fribidi.h


	install -Dm644 $pkgname.pc $pkgdir/usr/lib/pkgconfig/
	install -Dm644 f$pkgname.pc $pkgdir/usr/lib/pkgconfig/
}

license() {
	cd $pkgname-$pkver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
