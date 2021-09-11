pkgname=nss
pkgver=3.69

fetch() {
	curl "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_69_RTM/src/nss-3.69-with-nspr-4.32.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cd $pkgname

	sed -i '/-no-integrated-as/d' ./lib/freebl/Makefile
	sed -i '/-no-integrated-as/d' ./lib/freebl/freebl.gyp
	sed -i '/-no-integrated-as/d' ./lib/freebl/freebl_base.gypi
	
	sed -i 's/bash/zsh/g' build.sh
	./build.sh --opt --disable-tests

}

package() {
    srcdir=$(pwd)/..
	cd $pkgname-$pkgver

	install -m755 -d "$pkgdir"/usr/lib/pkgconfig
	install -m755 -d "$pkgdir"/usr/bin
	install -m755 -d "$pkgdir"/usr/include/nss/private

	NSS_VMAJOR=$(awk '/#define.*NSS_VMAJOR/ {print $3}' nss/lib/nss/nss.h)
	NSS_VMINOR=$(awk '/#define.*NSS_VMINOR/ {print $3}' nss/lib/nss/nss.h)
	NSS_VPATCH=$(awk '/#define.*NSS_VPATCH/ {print $3}' nss/lib/nss/nss.h)

	# pkgconfig files
	local _pc; for _pc in nss.pc nss-util.pc nss-softokn.pc; do
		sed "$srcdir"/$_pc.in \
			-e "s,%libdir%,/usr/lib,g" \
			-e "s,%prefix%,/usr,g" \
			-e "s,%exec_prefix%,/usr/bin,g" \
			-e "s,%includedir%,/usr/include/nss,g" \
			-e "s,%SOFTOKEN_VERSION%,$pkgver,g" \
			-e "s,%NSPR_VERSION%,$pkgver,g" \
			-e "s,%NSS_VERSION%,$pkgver,g" \
			-e "s,%NSSUTIL_VERSION%,$pkgver,g" \
			> "$pkgdir"/usr/lib/pkgconfig/$_pc
	done
	ln -sf nss.pc "$pkgdir"/usr/lib/pkgconfig/mozilla-nss.pc
	chmod 644 "$pkgdir"/usr/lib/pkgconfig/*.pc

	# nss-config
	sed "$srcdir"/nss-config.in \
		-e "s,@libdir@,/usr/lib,g" \
		-e "s,@prefix@,/usr/bin,g" \
		-e "s,@exec_prefix@,/usr/bin,g" \
		-e "s,@includedir@,/usr/include/nss,g" \
		-e "s,@MOD_MAJOR_VERSION@,${NSS_VMAJOR},g" \
		-e "s,@MOD_MINOR_VERSION@,${NSS_VMINOR},g" \
		-e "s,@MOD_PATCH_VERSION@,${NSS_VPATCH},g" \
		> "$pkgdir"/usr/bin/nss-config
	chmod 755 "$pkgdir"/usr/bin/nss-config
	local minor=${pkgver#*.}
	minor=${minor%.*}
	for file in $(find dist/Release/lib -name "*.so"); do
		install -m755 $file \
			"$pkgdir"/usr/lib/${file##*/}.$minor
		ln -s ${file##*/}.$minor "$pkgdir"/usr/lib/${file##*/}
	done
	install -m644 dist/Release/lib/*.a "$pkgdir"/usr/lib/
	install -m644 dist/Release/lib/*.chk "$pkgdir"/usr/lib/

	for file in certutil cmsutil crlutil modutil pk12util shlibsign \
			signtool signver ssltap; do
		install -m755 dist/Release/bin/$file "$pkgdir"/usr/bin/
	done
	install -m644 dist/public/nss/*.h "$pkgdir"/usr/include/nss/
	install -m644 dist/private/nss/blapi.h dist/private/nss/alghmac.h "$pkgdir"/usr/include/nss/private/


	
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
