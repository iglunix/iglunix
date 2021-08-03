# Based on Abyss OS phase1/devel/rust APKBUILD:
#
# Copyright (c) 2019 by the Abyss Authors
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

pkgname=rust
pkgver=beta

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

export RUSTROOT="/usr"
# export RUSTROOT="/usr/src/rust-bootstrap/build/rust-root"

fetch() {
	curl "https://static.rust-lang.org/dist/rustc-$pkgver-src.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz

	mv rustc-$pkgver-src $pkgname-$pkgver


	cp ../*.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-move-py.patch
	patch -p1 < ../abyss-install-template-shebang.patch
	patch -p1 < ../alpine-crt.patch
	patch -p1 < ../libexec.patch
	patch -p1 < ../llvm_crt.patch
	patch -p1 < ../unfreeze.patch
	patch -p1 < ../libresslssl.patch

	sed -i /LD_LIBRARY_PATH/d src/bootstrap/bootstrap.py
	_clear_vendor_checksums libc
	_clear_vendor_checksums openssl-sys
	_clear_vendor_checksums openssl-src
	_clear_vendor_checksums openssl

	cd ..
}

build() {
	cd $pkgname-$pkgver

	OPENSSL_LIB_DIR=/usr/lib/ ./configure \
		--build="$TRIPLE" \
		--host="$TRIPLE" \
		--target="$TRIPLE" \
		--prefix="/usr" \
		--musl-root="/usr" \
		--release-channel="beta" \
		--enable-local-rust \
		--local-rust-root=$RUSTROOT \
		--disable-docs \
		--enable-extended \
		--tools="cargo,rls,rustfmt,src" \
		--enable-vendor \
		--disable-locked-deps \
		--enable-option-checking \
		--python="python" \
		--llvm-root="/usr" \
		--llvm-libunwind="system" \
		--enable-llvm-link-shared \
		--set="target.$TRIPLE.llvm-config=/usr/bin/llvm-config" \
		--set="rust.musl-root=/usr" \
		--set="target.$TRIPLE.musl-root=/usr" \
		--set="target.$TRIPLE.crt-static=false" \
		--set="target.$TRIPLE.cc=cc" \
		--set="target.$TRIPLE.cxx=c++" \
		--set="target.$TRIPLE.ar=ar" \
		--set="target.$TRIPLE.linker=cc" \
		--set="target.$TRIPLE.crt-static=false" \
		--set="target.$TRIPLE.cc=cc" \
		--set="target.$TRIPLE.cxx=c++" \
		--set="target.$TRIPLE.ar=ar" \
		--set="target.$TRIPLE.linker=cc"

	sed 's/#deny-warnings = .*/deny-warnings = false/' -i config.toml
#	sed 's|deny(warnings,|deny(|' -i src/bootstrap/lib.rs

	./x.py build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR="$pkgdir" ./x.py install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE-MIT
#	cat COPYING
}
