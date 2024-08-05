pkgname=gtk+
_pkgver=3.24
pkgver=$_pkgver.36
deps="gdk-pixbuf:libepoxy:atk"

fetch() {
	curl -L "https://download.gnome.org/sources/gtk+/$_pkgver/gtk%2B-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir -p $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../../no-fribidi.patch

	# Remove 'atk-bridge' dependency which removes the 'dbus' dependency.
	sed '/atkbridge_dep/d;/atk-bridge-2.0/d' meson.build > _
	mv -f _ meson.build
	sed '/atkbridge_dep,/d' gtk/meson.build > _
	mv -f _ gtk/meson.build

	sed '/<atk-bridge.h>/d;/atk_bridge_adaptor_init/d' \
	    gtk/a11y/gtkaccessibility.c > _
	mv -f _ gtk/a11y/gtkaccessibility.c

sed '/fribidi_dep/d;/fribidi_req  /d;s/fribidi_req//;s/fribidi//' meson.build > _
mv -f _ meson.build
sed '/fribidi_dep,/d' gtk/meson.build > _
mv -f _ gtk/meson.build
sed '/fribidi_dep,/d' gdk/meson.build > _
mv -f _ gdk/meson.build


	rm subprojects/*.wrap

}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		--libdir=lib \
		--localstatedir=/var \
		-Dx11_backend=false \
		-Dprint_backends=auto \
		-Dwayland_backend=true \
		-Dwin32_backend=false \
		-Dquartz_backend=false \
		-Dcolord=no \
		-Ddemos=true \
		-Dexamples=false \
		-Dtests=false \
		-Dinstalled_tests=false \
		-Dgtk_doc=false \
		-Dintrospection=false

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
