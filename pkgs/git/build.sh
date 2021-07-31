pkgver=2.32.0
pkgname=git
pkgrel=1
deps="musl:zlib:curl:dropbear"
bad="gmake"
ext="doc"

fetch() {
	curl "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 prefix=/usr gitexecdir=lib/gitcore INSTALL_SYMLINKS=1
	# Need to run twice for it to work ¯\_(ツ)_/¯
	# Some issue with `msgfmt` 'cause I'm using gettext-tiny but idk why it works on the second run
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 prefix=/usr gitexecdir=lib/gitcore INSTALL_SYMLINKS=1
}

package() {
	cd $pkgname-$pkgver
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 install prefix=/usr gitexecdir=lib/gitcore DESTDIR=$pkgdir INSTALL_SYMLINKS=1
}

package_doc() {
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 install-man prefix=/usr DESTDIR=$pkgdir INSTALL_SYMLINKS=1
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
