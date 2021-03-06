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

fetch() {
	curl "https://static.rust-lang.org/dist/rustc-$pkgver-src.tar.gz" -o $pkgname-$pkgver.tar.xz
	curl -L "https://github.com/sfackler/rust-openssl/archive/refs/tags/openssl-v0.10.34.tar.gz" -o rust-openssl.tar.gz
#	curl -L "https://github.com/sfackler/rust-openssl/archive/master.tar.gz" -o rust-openssl.tar.gz
#	curl "https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz" -o $pkgname-
	tar -xf $pkgname-$pkgver.tar.xz
	tar -xf rust-openssl.tar.gz

	mv rustc-$pkgver-src $pkgname-$pkgver

#	tar -xf rust-openssl.tar.gz

#	cp rust-$pkgver/vendor/openssl/.cargo-checksum.json rust-openssl-master/openssl/
#	cp rust-$pkgver/vendor/openssl-sys/.cargo-checksum.json rust-openssl-master/openssl-sys/

#	rm -r rust-$pkgver/vendor/openssl-sys
#	rm -r rust-$pkgver/vendor/openssl
##	cp -r rust-openssl-master/openssl rust-$pkgver/vendor/openssl
#	cp -r rust-openssl-master/openssl-sys rust-$pkgver/vendor/openssl-sys
	
	cp ../*.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-move-py.patch
	patch -p1 < ../abyss-install-template-shebang.patch
	patch -p1 < ../abyss-libunwind.patch
	patch -p1 < ../abyss-libz.patch
#	patch -p1 < ../vendored-ssl.patch
#	patch -p1 < ../openbsd-libressl.patch
	patch -p1 < ../alpine-crt.patch
	patch -p1 < ../libexec.patch
	patch -p1 < ../llvm_crt.patch
	patch -p1 < ../unfreeze.patch

	sed -i /LD_LIBRARY_PATH/d src/bootstrap/bootstrap.py
	_clear_vendor_checksums libc
	_clear_vendor_checksums openssl-sys
	_clear_vendor_checksums openssl-src
	_clear_vendor_checksums openssl

	cp -r ../rust-openssl-openssl-v0.10.34/openssl/ vendor/
	cp -r ../rust-openssl-openssl-v0.10.34/openssl-sys/ vendor/
	sed vendor/openssl/Cargo.toml -i -e 's/0.10.34/0.10.30/g'
	sed vendor/openssl/Cargo.toml -i -e 's/0.9.62/0.9.58/g'
	sed vendor/openssl-sys/Cargo.toml -i -e 's/0.9.62/0.9.58/g'
	
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
		--release-channel="beta" \
		--enable-local-rust \
		--local-rust-root="/usr" \
		--disable-docs \
		--enable-extended \
		--tools="cargo,rls,rustfmt,src" \
		--enable-vendor \
		--disable-locked-deps \
		--enable-option-checking \
		--python="python" \
		--llvm-root="/usr" \
		--enable-llvm-link-shared \
		--set="target.x86_64-unknown-linux-musl.llvm-config=/usr/bin/llvm-config" \
		--set="rust.musl-root=/usr" \
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
		--set="target.x86_64-unknown-linux-musl.linker=cc"

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
	cat LICENSE-MIT
#	cat COPYING
}
