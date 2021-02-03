#!/bin/sh
usage() {
	echo $(basename "$0"): ERROR: "$@" 1>&2
	echo usage: $(basename "$0") '([-i]|[-u]|[-f]|[-l]) [-o root]
		[pkg.tar]' 1>&2
	exit 1
}

tar_fail() {
	echo "Failed to extract tar"
	exit 1
}

stat_fail() {
	echo "Not a valid package"
	echo "Missing package meta file"
	exit 1
}

find_fail() {
	echo "Package not installed"
	exit 1
}

continue_interactive() {
	printf '%s' "Do you wish to proceed?: "
	read yn
	case $yn in
		[Yy]* ) echo "Proceeding";;
		[Nn]* ) exit;;
		* ) exit;;
	esac
}

already_exists() {
	echo "Package already installed"
	echo "pass -u and -i to upgrade"
	exit 1
}

dep_not_found() {
	echo "Missing dep: $1"
	exit 1
}

i= u= l= f= o= d= iu=

case "$1" in
	-i) i=1;;
	-u) u=1;;
	-l) l=1;;
	-f) f=1;;
	-d) d=1;;
	-iu) iu=1;;
	-ui) iu=1;;
	*) usage "bad argument $i";;
esac
shift

while :
do
    case "$1" in
	-o) shift; o="$1";;
	--) shift; break;;
	-*) usage "bad argument $1";;
	*) break;;
    esac
    shift
done

if [ "$d" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null 2> /dev/null || find_fail
	grep deps /usr/share/lazypkg/$1 | tr '=' '\n' | grep -v deps | tr ':' '\n'

elif [ "$iu" = "1" ]; then
	# Setup names
	bname_we=$(basename "$1")
	bname=$(echo "$bname_we" |  cut -f 1 -d '.')

	# locate installed package
	stat /usr/share/lazypkg/$bname > /dev/null 2> /dev/null || find_fail

	echo "Upgrading $bname_we"
	continue_interactive

	# Extract new package and verify
	mkdir -p /tmp/lazybox/$bname_we || exit 1
	tar -xf $1 -C /tmp/lazybox/$bname_we || tar_fail
	stat /tmp/lazybox/$bname_we/usr/share/lazypkg/$bname >/dev/null || stat_fail

	# Check deps
	deps=$(grep deps /tmp/lazybox/$bname_we/usr/share/lazypkg/$bname | tr '=' '\n' | grep -v deps | tr ':' '\n')
	for dep in $deps; do
		stat /usr/share/lazypkg/$dep > /dev/null 2> /dev/null || dep_not_found $dep
    	done

	# Grab a list of old files and new files to install
	OFILES=$(sed -n '/\[fs\]/,$p' /usr/share/lazypkg/$bname |
		grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)
	NFILES=$(sed -n '/\[fs\]/,$p' /tmp/lazybox/$bname_we/usr/share/lazypkg/$bname |
		grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)

	# Extract tar
	tar -xf $1 -C /
	rm -r /tmp/lazybox/$bname_we


	# Remove old files (don't know if this works yet)
	for file in $OFILES; do
		if echo $NFILES | grep -q $file; then
			echo "not removing $file"
		else
    			echo "attempting to remove $file"
    			case $(stat -c "%F" /$file) in
        			directory) rmdir 2>/dev/null /$file;;
        			"regular file") rm /$file;;
        			"symbolic link") rm /$file;;
        			*) break;;
    			esac
    		fi
	done

	echo $OFILES
	echo $NFILES

elif [ "$i" = "1" ]; then
	bname_we=$(basename "$1")
	bname=$(echo "$bname_we" |  cut -f 1 -d '.')
	stat /usr/share/lazypkg/$bname > /dev/null 2> /dev/null && already_exists
	echo "Installing $bname_we"
	continue_interactive
	mkdir -p /tmp/lazybox/$bname_we || exit 1
	tar -xf $1 -C /tmp/lazybox/$bname_we || tar_fail
	stat /tmp/lazybox/$bname_we/usr/share/lazypkg/$bname >/dev/null || stat_fail
	deps=$(grep deps /tmp/lazybox/$bname_we/usr/share/lazypkg/$bname | tr '=' '\n' | grep -v deps | tr ':' '\n')
	for dep in $deps; do
		stat /usr/share/lazypkg/$dep > /dev/null 2> /dev/null || dep_not_found $dep
    	done
	tar -xf $1 -C /
	rm -r /tmp/lazybox/$bname_we
elif [ "$f" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null 2> /dev/null || find_fail
	sed -n '/\[fs\]/,$p' /usr/share/lazypkg/$1 | grep -v "\[fs\]"
elif [ "$l" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null 2> /dev/null || find_fail
	sed -n '/\[license\]/,/\[fs\]/{/\[license\]\|\[fs\]/!p}' /usr/share/lazypkg/$1
elif [ "$u" = "1" ]; then
	stat /usr/share/lazypkg/$1 > /dev/null 2> /dev/null || find_fail
	FILES=$(sed -n '/\[fs\]/,$p' /usr/share/lazypkg/$1 | grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)

	echo "Uninstalling $1"
	continue_interactive

	for file in $FILES; do
    		case $(stat -c "%F" /$file) in
        		directory) rmdir 2>/dev/null /$file;;
        		"regular file") rm /$file;;
        		"symbolic link") rm /$file;;
        		*) echo "can't remove $file";;
    		esac
    	done
fi
