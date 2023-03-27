pkgver=59c
pkgname=mksh
deps="musl"
bad=""
ext="doc"
auto_cross

fetch() {
	curl http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59c.tgz -o $pkgname-$pkgver.tar.gz
	curl http://www.mirbsd.org/TaC-mksh.txt -o license.txt
	tar -xf $pkgname-$pkgver.tar.gz
	mv $pkgname $pkgname-$pkgver
	cd $pkgname-$pkgver
	#patch -p1 < ../../procsub.patch
}

build() {
	cd $pkgname-$pkgver
	CPPFLAGS="-DMKSH_BINSHPOSIX" sh Build.sh -L
	sh Build.sh
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm755 ./mksh $pkgdir/bin
	install -Dm755 ./lksh $pkgdir/bin
	ln -sr $pkgdir/bin/mksh $pkgdir/bin/bash
	ln -sr $pkgdir/bin/lksh $pkgdir/bin/sh
}

backup() {
	return
}

license() {
	cat ../license.txt
}
