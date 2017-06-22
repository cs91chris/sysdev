#!/bin/bash

source sysdev/script/color.conf


FILE_LOG=~/.sysdev.log
CHEAT_REPO=https://github.com/jahendrie/cheat.git
CHEAT_PATH=/usr/share/cheat/sheets


ERR_EXIT=0
FILE_LOG=$HOME/.sysdev.log
touch $FILE_LOG
chmod 744 $FILE_LOG

TOOLS="
	unrar p7zip
	sudo git vim
	hdparm udisks2
	smartmontools acpitool
	lshw hddtemp lm-sensors
	figlet screenfetch pydf
	ipython python-pip pyflakes
	elinks wget curl nmap tcpdump
	glances ranger htop tmux tree
	colorgcc gcc gdb g++ indent valgrind
"

if [ "$1" == "--help" ]; then
	echo -e "\nAuthor: ${green}Christian Sannino${reset}"
	echo -e "Released under ${green}GPL v3 license${reset}\n"
	echo -e "This script installs this packages:"
	echo -e "$TOOLS"

	echo -e "In case of error see ${orange}$FILE_LOG${reset}\n"
	exit 0
fi


sudo apt update 2>> $FILE_LOG && {
	sudo apt install $TOOLS -y 2>> $FILE_LOG || ERR_EXIT=1
} || ERR_EXIT=1


if [ ! -x $(which cheat 2>/dev/null) ]
then
	echo -e "${orange}Installing${reset} cheat..."
	git clone $CHEAT_REPO 2>> $FILE_LOG || ERR_EXIT=1

	cd cheat > /dev/null
	sudo make install 2>> $FILE_LOG || ERR_EXIT=1
	chmod -R 744 $CHEAT_PATH

	cd - > /dev/null
	rm -rf cheat
fi


[ $ERR_EXIT -ne 0 ] && {
	echo -e "${red}An error occurred! See $FILE_LOG${reset}"
}

exit $ERR_EXIT


