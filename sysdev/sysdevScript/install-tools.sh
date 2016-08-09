#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]
	then
		echo -e "${green}installing tool...${reset}"
		apt-get update

		# utils
		apt-get install \
			sudo \
			tmux \
			pydf \
			htop \
			tree \
			elinks \
			ranger \
			figlet

		# system
		apt-get install \
			vim \
			lshw \
			nmap \
			python \
			glances \
			hddtemp \
			tcpdump \
			lm-sensors \
			screenfetch

		# develop
		apt-get install \
			vim \
			gcc \
			g++ \
			git \
			ipython \
			valgrind \
			pyflakes 

		addgroup $USER sudo
		logout 2> /dev/null

	else
		echo -e "you are not root: ${red}permission denied${reset}"
		exit 1
fi

