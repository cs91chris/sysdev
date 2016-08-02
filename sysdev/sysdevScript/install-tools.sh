#!/bin/bash

source ~/.script/color.conf


if [ $(id -u) -eq 0 ]

	then
		echo -e "${green}installing tool...${reset}"
		apt-get update && apt-get install \
			git \
			vim \
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
			lm-sensors
	else
		echo -e "you are not root: ${red}permission denied${reset}"

fi

