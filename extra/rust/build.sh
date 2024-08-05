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
pkgver=1.80.0
mkdeps="rust:python:pkgconf"
deps="llvm:musl:libcxx:libunwind:openssl:zlib-ng"

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

if [ -d /opt/rust/bin ]
then
	export RUSTROOT="/opt/rust"
else
	export RUSTROOT="/usr"
fi

fetch() {
	curl "https://static.rust-lang.org/dist/rustc-$pkgver-src.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz

	mv rustc-$pkgver-src $pkgname-$pkgver

	cp ../*.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-crt.patch
}

build() {
	cd $pkgname-$pkgver
    #	--tools="cargo,rls,rustfmt,src" \
	if [ ! -e config.toml ]
	then
		OPENSSL_LIB_DIR=/usr/lib/ ./configure \
			--build="$TRIPLE" \
			--host="$TRIPLE" \
			--target="$TRIPLE" \
			--prefix="/usr" \
			--musl-root="/usr" \
			--release-channel="stable" \
			--enable-local-rust \
			--local-rust-root=$RUSTROOT \
			--disable-docs \
			--enable-extended \
			--tools="cargo,rustfmt,rls,src" \
			--enable-vendor \
			--disable-locked-deps \
			--enable-option-checking \
			--python="python" \
			--llvm-root="/usr" \
			--llvm-libunwind="system" \
			--enable-llvm-link-shared \
			--set="llvm.use-libcxx" \
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
			--set="target.$TRIPLE.linker=cc" \
			--disable-llvm-static-stdcpp
	fi

	sed 's/#deny-warnings = .*/deny-warnings = false/' -i config.toml
#	sed 's|deny(warnings,|deny(|' -i src/bootstrap/lib.rs

	./x.py build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR="$pkgdir" ./x.py install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE-MIT
#	cat COPYING
}
