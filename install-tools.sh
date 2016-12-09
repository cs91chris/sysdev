#!/bin/bash

source ~/Script/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]; then
	apt-get update && apt-get install \
		git vim gcc gdb g++ \
		pydf lshw htop tmux nmap tree \
		elinks ranger indent figlet \
		glances ipython hddtemp tcpdump \
		pyflakes valgrind festival \
		python-pip cryptsetup lm-sensors \
		acpitool screenfetch secure-delete \
		poppler-utils smartmontools \
	-y

	git clone https://github.com/jahendrie/cheat.git
	cd cheat >/dev/null
	make install
	chmod -R 755 /usr/share/cheat/sheets/
	cd -
	rm -rf cheat

else
	echo -e "you are not root: ${red}permission denied${reset}"
	exit 1
fi

