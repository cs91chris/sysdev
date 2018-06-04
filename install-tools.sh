#!/bin/bash

SYSDEV_DIR=$(dirname "$0")
source $SYSDEV_DIR/sysdev/develop/include/bash/color.conf

mkdir $HOME/.log

FILE_LOG=$HOME/.log/sysdev.log
CHEAT_REPO=https://github.com/jahendrie/cheat.git
CHEAT_PATH=/usr/share/cheat/sheets

ERR_EXIT=0
touch $FILE_LOG
chmod 744 $FILE_LOG

TOOLS="
	sudo git vim most
	hdparm udisks2
	supervisor members
	smartmontools acpitool
	lshw hddtemp lm-sensors
	figlet screenfetch pydf
	python python3 virtualenv
	python-dev python3-dev
	elinks wget curl nmap tcpdump
	glances ranger htop tmux tree p7zip
	colorgcc gcc gdb g++ indent valgrind
"

if [[ $1 == "--help" ]]; then
	cat $SYSDEV_DIR/README.md
	echo -e "This script installs this packages:"
	echo -e "$TOOLS"
	echo -e "In case of error see ${orange}$FILE_LOG${reset}\n"
	exit 0
fi


sudo apt update 2>> $FILE_LOG && {
	sudo apt install $TOOLS -y 2>> $FILE_LOG || ERR_EXIT=1
} || ERR_EXIT=1


if [[ ! -x $(which cheat 2>/dev/null) ]]
then
	echo -e "${orange}Installing${reset} cheat..."
	git clone $CHEAT_REPO 2>> $FILE_LOG || ERR_EXIT=1

	cd cheat > /dev/null
	sudo make install 2>> $FILE_LOG || ERR_EXIT=1
	chmod -R 744 $CHEAT_PATH

	cd - > /dev/null
	rm -rf cheat
fi


if [[ $ERR_EXIT -ne 0 ]]; then
	echo -e "${red}An error occurred! See $FILE_LOG${reset}"
fi

exit $ERR_EXIT

