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
pkgver=1.79.0
pkgrel=1
mkdeps="rust:python:pkgconf"
deps="llvm:musl:libcxx:libunwind:openssl:zlib-ng"

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

if [ -d /opt/rust/bin ]
then
	export RUSTROOT="/opt/rust"
elif { -f /root/.cargo }
	export RUSTROOT="/root/.cargo"
else
	export RUSTROOT="/usr"
fi

fetch() {
	curl "https://static.rust-lang.org/dist/rustc-$pkgver-src.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz

	mv rustc-$pkgver-src $pkgname-$pkgver

	cp ../*.patch .
	cd $pkgname-$pkgver
	# patch -p1 < ../no_git_repo.patch
	patch -p1 < ../alpine-crt.patch
	# patch -p1 < ../fix-curl.patch
	# patch -p1 < ../libexec.patch
	# patch -p1 < ../lfs64-rust.patch
	# patch -p1 < ../offset.patch

	# patch -p1 -d vendor/getrandom-0.2.8 < ../lfs64-getrandom.patch

	#for dir in vendor/libc*
	#do
	#	_clear_vendor_checksums ${dir##vendor/}
	#	patch -p1 -d $dir < ../lfs64-libc.patch
	#done

	# sed -i '/config.check_build_rustc_version();/d' src/bootstrap/lib.rs
	# sed -i /LD_LIBRARY_PATH/d src/bootstrap/bootstrap.py
	# _clear_vendor_checksums curl
	# _clear_vendor_checksums curl-sys
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
