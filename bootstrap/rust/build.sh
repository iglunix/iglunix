pkgname=rust
pkgver=beta

fetch() {
	curl "https://static.rust-lang.org/dist/rust-$pkgver-$ARCH-unknown-linux-musl.tar.gz" -o rust.tar.gz
	tar -xf rust.tar.gz
}

build() {
	[ -f libgcc_s.so ] \
	|| clang -shared -o libgcc_s.so \
	-Wl,--allow-multiple-definition -Wl,--whole-archive \
	$(clang -print-libgcc-file-name) -lunwind
}

package() {
	[ -f $pkgdir/opt/rust/lib/rustlib/uninstall.sh ] \
	|| ./rust-$pkgver-$ARCH-unknown-linux-musl/install.sh \
	--disable-ldconfig \
	--destdir=$pkgdir \
	--prefix=/opt/rust

	[ -f $pkgdir/opt/rust/lib/libgcc_s.so.1 ] \
	|| cp ./libgcc_s.so $pkgdir/opt/rust/lib/libgcc_s.so.1
}

backup() {
	return
}

license() {
	return
}
