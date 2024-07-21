pkgname=pipewire
pkgver=1.2.1
pkgrel=1
mver=0.5.5
deps="dbus-glib"

fetch() {
	curl "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/$pkgver/pipewire-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	curl "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/$mver/wireplumber-$mver.tar.bz2" -O
	tar -xf $pkgname-$pkgver.tar.bz2
	mkdir $pkgname-$pkgver/build
	tar -xf wireplumber-$mver.tar.bz2 -C $pkgname-$pkgver/subprojects/
	mv $pkgname-$pkgver/subprojects/wireplumber-0.5.5 $pkgname-$pkgver/subprojects/wireplumber
	cd $pkgname-$pkgver
#	patch -p1 < ../../libudev-zero.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	CFLAGS="$CFLAGS -fPIC"\
	LDFLAGS="$LDFLAGS -Wl,--undefined-version"
	meson setup .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Ddocs=disabled \
		-Dexamples=disabled \
		-Dman=disabled \
		-Dinstalled_tests=disabled \
		-Dgstreamer=disabled \
		-Dsystemd=disabled \
		-Dpipewire-jack=enabled \
		-Dpipewire-alsa=enabled \
		-Dpipewire-v4l2=disabled \
		-Dudev=enable \
		-Dspa-plugins=enabled \
		-Dalsa=enabled \
		-Daudiomixer=enabled \
		-Dbluez5=disabled \
		-Dcontrol=enabled \
		-Daudiotestsrc=enabled \
		-Dffmpeg=disabled \
		-Djack=disabled \
		-Dsupport=enabled \
		-Devl=disabled \
		-Dv4l2=disabled \
		-Ddbus=enabled \
		-Dlibcamera=disabled \
		-Dvideoconvert=disabled \
		-Dvideotestsrc=disabled \
		-Dvolume=enabled \
		-Dvulkan=disabled \
		-Dpw-cat=enabled \
		-Dudev=enabled \
		-Dsdl2=disabled \
		-Dsndfile=enabled \
		-Dlibpulse=enabled \
		-Droc=disabled \
		-Davahi=disabled \
		-Dlibusb=disabled \
		-Draop=disabled \
		-Dlv2=disabled \
		-Dsession-managers="['wireplumber']"

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
