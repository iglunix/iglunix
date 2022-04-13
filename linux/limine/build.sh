pkgname=limine
pkgver=3.0.3
mkdeps="nasm:llvm"

fetch() {
	curl -L "https://github.com/limine-bootloader/limine/releases/download/v$pkgver/limine-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	# Limine's configure script rejects LLVM binutils because
	# objcopy can't build EFI. We only want bios though.
	sed \
		-e "s|@SRCDIR@|$(pwd)|g" \
		-e "s|@BUILDDIR@|$(pwd)|g" \
		-e "s|@PATH@|/usr/bad/gmake/bin:$PATH|" \
		-e 's|@prefix@|/usr|' \
		-e "s|@abs_builddir@|$(pwd)|" \
		-e "s|@abs_srcdir@|$(pwd)|" \
		-e 's|@CC@|cc|' \
		-e 's|@LIMINE_CC@|cc|' \
		-e 's|@LIMINE_CFLAGS@|-O3 -pipe -Wall -Wextra|' \
		-e 's|@LIMINE_LD@|ld|' \
		-e 's|@LIMINE_LDFLAGS@||' \
		-e 's|@LDFLAGS@||' \
		-e 's|@LIMINE_OBJCOPY@|objcopy|' \
		-e 's|@LIMINE_OBJDUMP@|objdump|' \
		-e 's|@LIMINE_READELF@|readelf|' \
		-e 's|@SED@|sed|' \
		-e 's|@HOST_CC@|cc|' \
		-e 's|@AWK@|awk|' \
		-e 's|@GREP@|grep|' \
		-e 's|@werror@||' \
		-e 's|@INSTALL@|install|' \
		-e 's|@CFLAGS@|-O3 -pipe -Wall -Wextra|' \
		-e "s|@limine_version@|$pkgver|" \
		-e 's|@LIMINE_AR@|ar|' \
		-e 's|@LIMINE_AS@|clang|' \
		-e 's|@WERROR@||' \
		GNUmakefile.in > GNUmakefile

	sed -e "s|@PACKAGE_VERSION@|$pkgver|" \
		-e "s|@LIMINE_COPYRIGHT@|$(grep Copyright LICENSE.md)|" \
		config.h.in > config.h

	bad --gmake gmake limine-bios limine-deploy CC="clang" TOOLCHAIN="llvm" TOOLCHAIN_CC="clang" TOOLCHAIN_LD="ld.lld" -j1
}

package() {
	cd $pkgname-$pkgver
	mkdir -p $pkgdir/usr/sbin/
	install -m 755 ./bin/limine-deploy $pkgdir/usr/sbin/
	mkdir -p $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-cd.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-hdd.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-pxe.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine.sys $pkgdir/usr/share/limine/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}

backup() {
	return
}
