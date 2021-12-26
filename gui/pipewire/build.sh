pkgname=pipewire
pkgver=0.3.42

fetch() {
	curl "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/$pkgver/pipewire-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
	mkdir $pkgname-$pkgver/build
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
		-Dpw-cat=disabled \
		-Dudev=disabled \
		-Dsdl2=disabled \
		-Dsndfile=disabled \
		-Dlibpulse=disabled \
		-Droc=disabled \
		-Davahi=disabled \
		-Dlibusb=disabled \
		-Draop=disabled \
		-Dlv2=disabled \
		-Dsession-managers="[]"

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
