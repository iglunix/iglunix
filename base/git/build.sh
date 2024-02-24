pkgver=2.44.0
pkgname=git
pkgrel=1
mkdeps="zlib-ng:curl:bad:gmake"
deps="zlib-ng:curl:openssl"
bad="gmake"
ext="doc"

fetch() {
	curl "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_EXPAT=1 NO_GETTEXT=1 NO_MSGFMT_EXTENDED_OPTIONS=1 prefix=/usr gitexecdir=lib/gitcore INSTALL_SYMLINKS=1
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_EXPAT=1 NO_GETTEXT=1 NO_MSGFMT_EXTENDED_OPTIONS=1 install prefix=/usr gitexecdir=lib/gitcore DESTDIR=$pkgdir INSTALL_SYMLINKS=1
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
