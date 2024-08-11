pkgname=sway
pkgver=1.9
pkgrel=2
deps="musl:pkgconf:wayland:json-c:pcre2:wlroots:pango:xkeyboard-config"

fetch() {
	curl -L "https://github.com/swaywm/sway/releases/download/$pkgver/sway-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	# curl -L "https://github.com/swaywm/sway/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Ddefault-wallpaper=true \
		-Dzsh-completions=true \
		-Dbash-completions=false \
		-Dfish-completions=false \
		-Db_lto=true \
		-Dsd-bus-provider=basu \
		-Db_ndebug=false -Dwerror=false \
		-Dxwayland=disabled \
		-Dtray=disabled \
		-Dgdk-pixbuf=disabled \
		-Dman-pages=disabled
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	echo /etc/sway/config
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
