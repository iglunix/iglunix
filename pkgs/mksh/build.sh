pkgver=59c
pkgname=mksh
deps="musl"
bad=""
ext="doc"

fetch() {
	curl https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59c.tgz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname
	CPPFLAGS="-DMKSH_BINSHPOSIX" sh Build.sh -L
	sh Build.sh
}

package() {
	cd $pkgname
	install -d $pkgdir/bin
	install -Dm755 ./mksh $pkgdir/bin
	install -Dm755 ./lksh $pkgdir/bin
	ln -sr $pkgdir/bin/mksh $pkgdir/bin/bash
	ln -sr $pkgdir/bin/lksh $pkgdir/bin/sh
}

package_doc() {
    	cd $pkgname
	install -d $pkgdir/usr/share/man/man1
	install -Dm 644 ./mksh.1 $pkgdir/usr/share/man/man1
	install -Dm 644 ./lksh.1 $pkgdir/usr/share/man/man1
}

license() {
	curl http://www.mirbsd.org/TaC-mksh.txt
}
