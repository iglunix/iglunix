pkgname=bzip2
pkgver=1.0.8
ext=dev

fetch() {
	curl "https://sourceware.org/pub/bzip2/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver

	make -f Makefile-libbz2_so CC=cc
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/lib/
	install -Dm755 ./libbz2.so.$pkgver $pkgdir/usr/lib/
	ln -sr $pkgdir/usr/lib/libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so
	ln -sr $pkgdir/usr/lib/libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so.1
	ln -sr $pkgdir/usr/lib/libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so.1.0
}

package_dev() {
    cd $pkgname-$pkgver
    install -d $pkgdir/usr/include/
    install -Dm644 ./bzlib.h $pkgdir/usr/include/
    install -d $pkgdir/usr/share/pkgconfig/

	cat > $pkgdir/usr/share/pkgconfig/bzip2.pc << EOF
prefix=/usr
exec_prefix=/usr
bindir=${exec_prefix}/bin
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: bzip2
Description: A file compression library
Version: @VERSION@
Libs: -L${libdir} -lbz2
Cflags: -I${includedir}
EOF

    
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
