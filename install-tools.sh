#!/bin/bash

source sysdev/script/color.conf


FILE_LOG=~/.sysdev.log
CHEAT_REPO=https://github.com/jahendrie/cheat.git
CHEAT_PATH=/usr/share/cheat/sheets


touch ~/.sysdev.log
chmod 755 ~/.sysdev.log


if [ "$1" == "--help" ]; then
	echo -e "\nAuthor: ${green}Christian Sannino${reset}"
	echo -e "Released under ${green}GPL v3 license${reset}\n"
	echo -e "This script installs this packages:"
	echo -e "\t unrar 7z sudo git vim"
	echo -e "\t smartmontools acpitool"
	echo -e "\t lshw hddtemp lm-sensors"
	echo -e "\t figlet screenfetch pydf"
	echo -e "\t ipython python-pip pyflakes"
	echo -e "\t elinks wget curl nmap tcpdump"
	echo -e "\t glances ranger htop tmux tree"
	echo -e "\t colorgcc gcc gdb g++ indent valgrind"
	echo -e "In case of error see ${orange}~/.sysdev.log${reset}\n"
	exit 0
fi


if [ $(id -u) -eq 0 ]
then
	apt update 2>> $FILE_LOG &&
	{
		apt install \
			unrar p7zip \
			sudo git vim \
			smartmontools acpitool \
			lshw hddtemp lm-sensors \
			figlet screenfetch pydf \
			ipython python-pip pyflakes \
			elinks wget curl nmap tcpdump \
			glances ranger htop tmux tree \
			colorgcc gcc gdb g++ indent valgrind
		-y 2>> $FILE_LOG
	}


	if [ ! "$(which cheat)" ]
	then
		echo -e "${orange}Installing${reset} cheat..."
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


