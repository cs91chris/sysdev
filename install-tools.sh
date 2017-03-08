#!/bin/bash

set -o errexit
source sysdev/Script/color.conf 2> /dev/null


FILE_LOG=~/.sysdev.log
CHEAT_REPO=https://github.com/jahendrie/cheat.git
CHEAT_PATH=/usr/share/cheat/sheets/


if [ $(id -u) -eq 0 ]
then
	apt update 2>> $FILE_LOG &&
	{
		apt install \
			colorgcc pyflakes valgrind \
			poppler-utils smartmontools \
			elinks ranger indent figlet \
			git vim gcc gdb g++ wget curl \
			pydf lshw htop tmux nmap tree \
			glances ipython hddtemp tcpdump \
			python-pip cryptsetup lm-sensors \
			acpitool screenfetch secure-delete \
		-y 2>> $FILE_LOG
	}

	if [ "$(which cheat)" == "" ]
	then
		git clone $CHEAT_REPO 2>> $FILE_LOG
		cd cheat > /dev/null
		make install 2>> $FILE_LOG
		chmod -R 755 $CHEAT_PATH
		cd - > /dev/null
		rm -rf cheat
	fi
	echo -e "see ${orange}~/.sysdev.log${reset}"

else
	echo -e "you are not root: ${red}permission denied${reset}"
	exit 1
fi


