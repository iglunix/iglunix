pkgname=firefox
pkgver=91.4.0
mkdeps="cbindgen:rust"

fetch() {
	return
	curl "https://ftp.mozilla.org/pub/firefox/releases/${pkgver}esr/source/firefox-${pkgver}esr.source.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	return
	cd $pkgname-$pkgver


	export MACH_USE_SYSTEM_PYTHON=1
	export CXXSTDLIB=c++
	export RUSTFLAGS='-C target-feature=-crt-static'

#     cat > .mozconfig << EOF
# ac_add_options --enable-default-toolkit=cairo-gtk3-wayland
# ac_add_options --prefix=/usr
# ac_add_options --libdir=/usr/lib
# ac_add_options --enable-alsa
# ac_add_options --enable-strip
# ac_add_options --enable-release
# ac_add_options --enable-rust-simd
# ac_add_options --enable-install-strip
# ac_add_options --enable-official-branding
# ac_add_options --enable-application=browser
# ac_add_options --enable-optimize="${CFLAGS:-} -w"
# ac_add_options --without-system-libvpx
# ac_add_options --without-system-ffi
# ac_add_options --without-system-png
# ac_add_options --without-system-jpeg
# ac_add_options --without-system-zlib
# ac_add_options --without-system-pixman
# ac_add_options --without-system-nss
# ac_add_options --without-system-nspr
# ac_add_options --disable-dbus
# ac_add_options --disable-gold
# ac_add_options --disable-tests
# ac_add_options --disable-vtune
# ac_add_options --disable-updater
# ac_add_options --disable-jemalloc
# ac_add_options --disable-callgrind
# ac_add_options --disable-profiling
# ac_add_options --disable-necko-wifi
# ac_add_options --disable-crashreporter
# ac_add_options --disable-pulseaudio
# ac_add_options --disable-accessibility
# ac_add_options --disable-debug
# ac_add_options --disable-debug-symbols
# ac_add_options --disable-parental-controls
# ac_add_options --disable-system-extension-dirs
# ac_add_options --disable-webrtc
# EOF

#ac_add_options --disable-eme
#ac_add_options --disable-elf-hack
	bad --gmake ./mach build
}

package() {
	cd $pkgname-$pkgver

	export MACH_USE_SYSTEM_PYTHON=1
	export CXXSTDLIB=c++
	export RUSTFLAGS='-C target-feature=-crt-static'


	bad --gmake ./mach install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
