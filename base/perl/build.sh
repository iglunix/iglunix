pkgname=perl
pkgver=5.38.0
mkdeps="bmake"
deps="musl"

fetch() {
	curl "https://www.cpan.org/src/5.0/perl-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver

	./Configure -des \
		-Dccflags="$CFLAGS" \
		-Dcccdlflags='-fPIC' \
		-Dcccdlflags='-fPIC' \
		-Dccdlflags='-rdynamic' \
		-Dprefix=/usr \
		-Dprivlib=/usr/share/perl5/core_perl \
		-Darchlib=/usr/lib/perl5/core_perl \
		-Dvendorprefix=/usr \
		-Dvendorlib=/usr/share/perl5/vendor_perl \
		-Dvendorarch=/usr/lib/perl5/vendor_perl \
		-Dsiteprefix=/usr/local \
		-Dsitelib=/usr/local/share/perl5/site_perl \
		-Dsitearch=/usr/local/lib/perl5/site_perl \
		-Dlocincpth=' ' \
		-Duselargefiles \
		-Dusethreads \
		-Duseshrplib \
		-Dd_semctl_semun \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dinstallman1dir=/usr/share/man/man1 \
		-Dinstallman3dir=/usr/share/man/man3 \
		-Dman1ext='1' \
		-Dman3ext='3pm' \
		-Dcf_by='Iglunix' \
		-Ud_csh \
		-Dusenm

	make libperl.so && make || return 1
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -rf $pkgdir/usr/share/man
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat Copying
}
