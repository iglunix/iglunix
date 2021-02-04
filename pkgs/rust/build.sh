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
pkgver=1.49.0


_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

fetch() {
	curl "https://static.rust-lang.org/dist/rustc-$pkgver-src.tar.gz" -o $pkgname-$pkgver.tar.xz
#	curl "https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz" -o $pkgname-
	tar -xf $pkgname-$pkgver.tar.xz

	mv rustc-$pkgver-src $pkgname-$pkgver
	cp ../*.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-move-py.patch
	patch -p1 < ../abyss-install-template-shebang.patch
	patch -p1 < ../abyss-libunwind.patch
	patch -p1 < ../abyss-libz.patch
	patch -p1 < ../vendored-ssl.patch
	patch -p1 < ../alpine-crt.patch

	sed -i /LD_LIBRARY_PATH/d src/bootstrap/bootstrap.py
	_clear_vendor_checksums libc
	_clear_vendor_checksums openssl-sys
	_clear_vendor_checksums openssl-src
	rm -rf src/llvm-project/

	cd ..
	ln -s /usr/bin/gmake make
}

build() {
	cd $pkgname-$pkgver

	OPENSSL_LIB_DIR=/usr/lib/ ./configure \
		--build="x86_64-unknown-linux-musl" \
		--host="x86_64-unknown-linux-musl" \
		--target="x86_64-unknown-linux-musl" \
		--prefix="/usr" \
		--release-channel="stable" \
		--enable-local-rust \
		--local-rust-root="/usr" \
		--llvm-root="/usr" \
		--disable-docs \
		--enable-extended \
		--tools="cargo" \
		--enable-vendor \
		--enable-locked-deps \
		--enable-llvm-link-shared \
		--enable-option-checking \
		--python="python" \
		--set="rust.musl-root=/usr" \
		--set="target.x86_64-unknown-linux-musl.llvm-config=/usr/bin/llvm-config" \
		--set="target.x86_64-unknown-linux-musl.musl-root=/usr" \
		--set="target.x86_64-unknown-linux-musl.crt-static=false" \
		--set="target.x86_64-unknown-linux-musl.cc=cc" \
		--set="target.x86_64-unknown-linux-musl.cxx=c++" \
		--set="target.x86_64-unknown-linux-musl.ar=ar" \
		--set="target.x86_64-unknown-linux-musl.linker=cc" \
		--set="target.x86_64-unknown-linux-musl.musl-root=/usr" \
		--set="target.x86_64-unknown-linux-musl.crt-static=false" \
		--set="target.x86_64-unknown-linux-musl.cc=cc" \
		--set="target.x86_64-unknown-linux-musl.cxx=c++" \
		--set="target.x86_64-unknown-linux-musl.ar=ar" \
		--set="target.x86_64-unknown-linux-musl.linker=cc" \
		--set="build.rustc=/root/lazybox/diskroot/usr/bin/rustc" \
		--set="build.cargo=/root/lazybox/diskroot/usr/bin/cargo"

	sed 's/#deny-warnings = .*/deny-warnings = false/' -i config.toml
	sed 's|deny(warnings,|deny(|' -i src/bootstrap/lib.rs

	PATH=$(pwd)"/..:$PATH" ./x.py build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR="$pkgdir" ./x.py install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
