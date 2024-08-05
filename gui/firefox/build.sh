pkgname=firefox
pkgver=116.0
mkdeps="cbindgen:rust"

_clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' third_party/rust/$1/.cargo-checksum.json
}

fetch() {
	#curl "https://ftp.mozilla.org/pub/firefox/releases/${pkgver}esr/source/firefox-${pkgver}esr.source.tar.xz" -o $pkgname-$pkgver.tar.xz
	#curl "https://hg.mozilla.org/mozilla-unified/archive/26726cd430955db041e5de33d9792bb816c57608.zip" -o $pkgname-$pkgver.zip
	curl "https://archive.mozilla.org/pub/firefox/releases/${pkgver}/source/firefox-${pkgver}.source.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	# patch -p1 < ../../no-x11.patch
	# patch -p1 < ../../fix-clang-as.patch
	# patch -p1 < ../../avoid-redefinition.patch
	# patch -p1 < ../../libcxx.patch
	# patch -p1 < ../../grefptr.patch
	patch -p1 < ../../sandbox-allow-select.patch
	patch -p1 < ../../audio-lfs64.patch

	_clear_vendor_checksums audio_thread_priority
	# patch -p1 < ../../sandbox-fork.patch
	# patch -p1 < ../../sandbox-sched.patch
}

build() {
	cd $pkgname-$pkgver
	ulimit -n 4096


	export MACH_USE_SYSTEM_PYTHON=1
	export CXXSTDLIB=c++
	export LDFLAGS="$LDFLAGS -Wl,-rpath=/usr/lib/firefox/,--enable-new-dtags"

	cat > .mozconfig << EOF
ac_add_options --enable-default-toolkit=cairo-gtk3-wayland
ac_add_options --prefix=/usr
ac_add_options --libdir=/usr/lib
ac_add_options --disable-alsa
ac_add_options --enable-dbus
ac_add_options --enable-strip
ac_add_options --enable-release
ac_add_options --enable-rust-simd
ac_add_options --enable-install-strip
ac_add_options --with-branding=browser/branding/nightly
ac_add_options --enable-update-channel=nightly
ac_add_options --enable-application=browser
ac_add_options --enable-optimize="-O3 -w"
ac_add_options --without-system-libvpx
ac_add_options --without-system-ffi
ac_add_options --without-system-png
ac_add_options --without-system-jpeg
ac_add_options --without-system-zlib
ac_add_options --without-system-pixman
ac_add_options --without-system-nss
ac_add_options --without-system-nspr
ac_add_options --enable-linker=lld
ac_add_options --disable-tests
ac_add_options --disable-vtune
ac_add_options --disable-updater
ac_add_options --disable-jemalloc
ac_add_options --disable-callgrind
ac_add_options --disable-profiling
ac_add_options --disable-necko-wifi
ac_add_options --disable-crashreporter
ac_add_options --enable-pulseaudio
ac_add_options --disable-accessibility
ac_add_options --disable-debug
ac_add_options --disable-debug-symbols
ac_add_options --disable-parental-controls
ac_add_options --disable-system-extension-dirs
ac_add_options --enable-webrtc
ac_add_options --disable-elf-hack
ac_add_options --without-wasm-sandboxed-libraries
#ac_add_options MOZ_PGO=1
EOF

	bad --gmake --autoconf ./mach build
}

package() {
	cd $pkgname-$pkgver

	export MACH_USE_SYSTEM_PYTHON=1
	export CXXSTDLIB=c++
	export RUSTFLAGS='-C target-feature=-crt-static'
	export LDFLAGS="$LDFLAGS -Wl,-rpath=/usr/lib/firefox/,--enable-new-dtags"

	DESTDIR=$pkgdir bad --gmake --autoconf ./mach install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
