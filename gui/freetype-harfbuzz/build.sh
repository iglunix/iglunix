f_pkgver=2.11.0
h_pkgver=3.0.0

pkgname=freetype-harfbuzz
pkgver=$f_pkgver+$h_pkgver

fetch() {
	curl "https://download-mirror.savannah.gnu.org/releases/freetype/freetype-$f_pkgver.tar.xz" \
	-o freetype-$f_pkgver.tar.xz

	tar -xf freetype-$f_pkgver.tar.xz
	mkdir -p freetype-$f_pkgver/build
	
	curl -L "https://github.com/harfbuzz/harfbuzz/releases/download/$h_pkgver/harfbuzz-$h_pkgver.tar.xz" \
	-o harfbuzz-$h_pkgver.tar.xz

	tar -xf harfbuzz-$h_pkgver.tar.xz
	mkdir -p harfbuzz-$h_pkgver/build
}

build() {
    mkdir tmp_install
    export DESTDIR=$(pwd)/tmp_install
    mkdir -p $DESTDIR/usr/include/harfbuzz
    # cp harfbuzz-$h_pkgver/src/hb-ft.h  $DESTDIR/usr/include/harfbuzz

    # Point Freetype to the Harfbuzz files.
    export CFLAGS="$CFLAGS -I$DESTDIR/usr/include/harfbuzz"
    export CFLAGS="$CFLAGS -L$DESTDIR/usr/lib "
    export PKG_CONFIG_PATH=$DESTDIR/usr/lib/pkgconfig

    # Point Harfbuzz to the Freetype files.
    export CXXFLAGS="$CXXFLAGS -I$DESTDIR/usr/include/freetype2"
    export CXXFLAGS="$CXXFLAGS -L$DESTDIR/usr/lib"

    cd freetype-$f_pkgver/build
    meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dbzip2=disabled \
		-Dzlib=disabled \
		-Dharbuzz=disabled

	samu

	samu install

	cd ../../

	cd harfbuzz-$h_pkgver/

	./configure \
	--prefix=/usr \
	--with-bzip2=no \
	--with-png=no \
	--with-brotli=no

	bad --gmake gmake
	bad --gmake gmake install

	cd ..

    cd freetype-$f_pkgver/build
    meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dbzip2=disabled \
		-Dzlib=disabled \
		-Dharfbuzz=enabled
		--reconfigure

	samu
}



package() {
	cd freetype-$f_pkgver
	cd build
	DESTDIR=$pkgdir samu install
	cd ../../
	cd harfbuzz-$h_pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

license() {
	cd freetype-$f_pkgver
	cat LICENSE
	cd harfbuzz-$h_pkgver
	cat COPYING
}
