#!/bin/bash

source ~/sysdevScript/color.conf


if [ $(id -u) -eq 0 ]; then
	echo -e "${green}installing tool...${reset}"
	apt-get update && apt-get install \
		git \
		vim \
		gcc \
		g++ \
		sudo \
		nmap \
		tmux \
		htop \
		pydf \
		tree \
		lshw \
		figlet \
		ranger \
		elinks \
		glances \
		hddtemp \
		tcpdump \
		valgrind \
		lm-sensors \
		screenfetch

	addgroup $USER sudo
	logout

	else
		echo -e "you are not root: ${red}permission denied${reset}"
fi

