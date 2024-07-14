pkgname=river
pkgver=master
_zig_wayland_ver=master
_zig_xkbcommon_ver=master
_zig_pixman_ver=master
_zig_wlroots_ver=master

ifetch() {
	curl -L "https://github.com/ifreund/river/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	curl -L "https://github.com/ifreund/zig-wayland/archive/refs/heads/master.tar.gz" -o zig-wayland-$_zig_wayland_ver.tar.gz
	curl -L "https://github.com/ifreund/zig-xkbcommon/archive/refs/heads/master.tar.gz" -o zig-xkbcommon-$_zig_xkbcommon_ver.tar.gz
	curl -L "https://github.com/ifreund/zig-pixman/archive/refs/heads/master.tar.gz" -o zig-pixman-$_zig_pixman_ver.tar.gz
	curl -L "https://github.com/swaywm/zig-wlroots/archive/refs/heads/master.tar.gz" -o zig-wlroots-$_zig_wlroots_ver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	cd deps
	tar -xf ../../zig-wayland-$_zig_wayland_ver.tar.gz
	mv zig-wayland-$_zig_wayland_ver/* zig-wayland
	tar -xf ../../zig-xkbcommon-$_zig_xkbcommon_ver.tar.gz
	mv zig-xkbcommon-$_zig_xkbcommon_ver/* zig-xkbcommon
	tar -xf ../../zig-pixman-$_zig_pixman_ver.tar.gz
	mv zig-pixman-$_zig_pixman_ver/* zig-pixman
	tar -xf ../../zig-wlroots-$_zig_wlroots_ver.tar.gz
	mv zig-wlroots-$_zig_wlroots_ver/* zig-wlroots
}

build() {
	cd $pkgname-$pkgver
	zig build -Drelease-safe --prefix /usr
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir zig build -Drelease-safe --prefix /usr install
	# Iglunix has alacritty packaged
	sed -i 's/foot/alacritty/g' $pkgdir/etc/river/init
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
