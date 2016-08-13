#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]; then
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
			figlet \
			cryptsetup \
			poppler-utils \
			secure-delete

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
		echo -e "${orange}you must logout${reset}"

	else
		echo -e "you are not root: ${red}permission denied${reset}"
		exit 1
fi

