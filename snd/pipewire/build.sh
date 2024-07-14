pkgname=pipewire
pkgver=0.3.64
mver=0.4.2
deps="dbus-glib"

ifetch() {
	curl "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/$pkgver/pipewire-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	curl "https://gitlab.freedesktop.org/pipewire/media-session/-/archive/$mver/media-session-$mver.tar.bz2" -O
	tar -xf $pkgname-$pkgver.tar.bz2
	mkdir $pkgname-$pkgver/build
	tar -xf media-session-$mver.tar.bz2 -C $pkgname-$pkgver/subprojects/
	mv $pkgname-$pkgver/subprojects/media-session-$mver $pkgname-$pkgver/subprojects/media-session
	cd $pkgname-$pkgver
	patch -p1 < ../../libudev-zero.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Ddocs=disabled \
		-Dexamples=disabled \
		-Dman=disabled \
		-Dinstalled_tests=disabled \
		-Dgstreamer=disabled \
		-Dsystemd=disabled \
		-Dpipewire-jack=disabled \
		-Dpipewire-alsa=enabled \
		-Dpipewire-v4l2=disabled \
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
		-Dsession-managers="['media-session']"

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
