#!/bin/bash

source ~/Script/color.conf 2> /dev/null

CHEAT_REPO=https://github.com/jahendrie/cheat.git


if [ $(id -u) -eq 0 ]; then
	apt update && apt install \
		vim gcc gdb g++ wget \
		pydf lshw htop tmux nmap tree \
		elinks ranger indent figlet \
		glances ipython hddtemp tcpdump \
		pyflakes valgrind \
		python-pip cryptsetup lm-sensors \
		acpitool screenfetch secure-delete \
		poppler-utils smartmontools \
	-y

	git clone $CHEAT_REPO
	cd cheat >/dev/null
	make install
	chmod -R 755 /usr/share/cheat/sheets/
	cd -
	rm -rf cheat

else
	echo -e "you are not root: ${red}permission denied${reset}"
	exit 1
fi

