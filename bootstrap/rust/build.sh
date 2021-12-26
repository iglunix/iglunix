pkgname=rust
pkgver=beta

fetch() {
	stat rust.tar.gz > /dev/null 2> /dev/null \
	|| curl "https://static.rust-lang.org/dist/rust-$pkgver-$ARCH-unknown-linux-musl.tar.gz" -o rust.tar.gz

	stat rust-$pkgver-$ARCH-unknown-linux-musl > /dev/null 2> /dev/null \
	|| tar -xf rust.tar.gz
}

build() {
	stat libgcc_s.so > /dev/null 2> /dev/null \
	|| clang -shared -o libgcc_s.so \
	-Wl,--allow-multiple-definition -Wl,--whole-archive \
	$(clang -print-libgcc-file-name)
}

package() {
	stat $pkgdir/opt/rust/lib/rustlib/uninstall.sh > /dev/null 2> /dev/null \
	|| ./rust-$pkgver-$ARCH-unknown-linux-musl/install.sh \
	--disable-ldconfig \
	--destdir=$pkgdir \
	--prefix=/opt/rust

	stat $pkgdir/opt/rust/lib/libgcc_s.so \
	|| cp ./libgcc_s.so $pkgdir/opt/rust/lib/libgcc_s.so
}

backup() {
	return
}

license() {
	return
}
