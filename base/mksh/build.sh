pkgver=59c
pkgname=mksh
deps="musl"
bad=""
ext="doc"
desc="MirBSD Korn Shell"
auto_cross

iifetch() {
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
	ln -s mksh $pkgdir/bin/bash
	ln -s lksh $pkgdir/bin/sh
}

backup() {
	return
}

license() {
	cat license.txt
}
