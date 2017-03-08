#!/bin/bash

set -o errexit
source ~/Script/color.conf 2> /dev/null


LOG_FILE=~/.sysdev.log
CHEAT_REPO=https://github.com/jahendrie/cheat.git
CHEAT_PATH=/usr/share/cheat/sheets/


if [ $(id -u) -eq 0 ]
then
	apt update 2> $LOG_FILE &&
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
		-y 2> $LOG_FILE
	}

	git clone $CHEAT_REPO 2> $LOG_FILE
	cd cheat > /dev/null
	make install 2> $LOG_FILE
	chmod -R 755 $CHEAT_PATH
	cd - > /dev/null
	rm -rf cheat

	echo -e "see ${orange}~/.sysdev.log${reset}"

else
	echo -e "you are not root: ${red}permission denied${reset}"
	exit 1
fi


