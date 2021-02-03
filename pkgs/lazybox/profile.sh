# Setup Path
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export POSIX_ME_HARDER=1

# Setup Shell Prompt
if [ "$(whoami)" == "root" ]; then
	export PS1=$(hostname)"# "
else
	export PS1=$(hostname)"$ "
fi

# Replace TERM with xterm because netbsd-curses doesn't include alacritty
if [ "$TERM" == "alacritty" ]; then
	export TERM=xterm
fi

# load profile
for file in $(ls /etc/profile.d); do
	. /etc/profile.d/$file
done
