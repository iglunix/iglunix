pkgname=lilo
pkgver=24.2

fetch() {
	curl "http://ftp.debian.org/debian/pool/main/l/lilo/lilo_$pkgver.orig.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/0001-fix-build-with-clang.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/01_makefile-adds.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/03_keytab-lilo.8-debian-based.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/05_readme.disk-change.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/06_notinteractive.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/07_hardening-cflags%2Bcppflags.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/08_small-typos-in-manpages.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/09_fix-manpage-lilo-conf-5.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/10_fix-manpage-lilo-conf-5.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/11_fix-gcc-10.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/lilo-24.1-remove-O_ACCMODE.patch" | patch -p1
	curl -L "https://raw.githubusercontent.com/ataraxialinux/ataraxia/master/stuff/lilo/lilo-24.1-remove__GLIBC__.patch" | patch -p1

	sed -i Makefile src/Makefile \
		-e '/strip/d;s|^	make|	$(MAKE)|g' \
		-e '/images install/d' \
		-e '/images all/d'	

	patch -p1 < ../../checkit.patch
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake CC="${CC:-clang}"
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
