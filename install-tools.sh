#!/bin/bash

source ~/Script/color.conf 2> /dev/null


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
			festival \
			acpi-tools \
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
			indent \
			ipython \
			valgrind \
			pyflakes

		echo -e "${orange}you must add your user to sudo group. Then logout${reset}"

	else
		echo -e "you are not root: ${red}permission denied${reset}"
		exit 1
fi

