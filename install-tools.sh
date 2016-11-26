#!/bin/bash

source ~/Script/color.conf 2> /dev/null


if [ $1 == "" ]; then
	echo -e "${red}missing${reset} argument try help"
	exit 1
fi

if [ $1 == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}\n"
	echo -e "./install-tools.sh ${green}help${reset}: for this information"
	echo -e "./install-tools.sh ${green}full${reset}: install all tools"
	echo -e "./install-tools.sh ${green}sys${reset}: install only tools for system administration"
	echo -e "./install-tools.sh ${green}dev${reset}: install only tools for develop with c and python"

	exit 0
fi

if [ $(id -u) -eq 0 ]; then
	apt-get update

	# utils
	apt-get install \
		git \
		vim \
		sudo \
		pydf \
		tree \
		ranger \
		figlet \
		festival \
		poppler-utils \

	# system tools
	if [[ $1 == "full" || $1 == "sys" ]]; then
		apt-get install \
			lshw \
			htop \
			tmux \
			nmap \
			elinks \
			glances \
			hddtemp \
			tcpdump \
			python-pip \
			cryptsetup \
			lm-sensors \
			acpi-tools \
			screenfetch \
			secure-delete \
			smartmontools

		git clone https://github.com/jahendrie/cheat.git
		cd cheat
		make install
		chmod -R 755 /usr/share/cheat/sheets/
		cd -
		rm -rf cheat
	fi

	# develop tools
	if [[ $1 == "full" || $1 == "dev" ]]; then
		apt-get install \
			gcc \
			gdb \
			g++ \
			indent \
			ipython \
			valgrind \
			pyflakes
	fi

	echo -e "${orange}you must add your user to sudo group. Then logout${reset}"

else
	echo -e "you are not root: ${red}permission denied${reset}"
	exit 1
fi

