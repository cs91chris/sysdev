#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]; then
	echo -e "${green}installing tool...${reset}"
	apt-get update && apt-get install \
		lightdm \
		mate-desktop-environment \
		network-manager-gnome \
		cups \
		system-config-printer \
		simple-scan \
		gparted \
		vlc \
		liferea \
		icedove \
		firefox-esr \
		transmission \
		dia \
		gpaint \
		bleachbit

	else
		echo -e "you are not root: ${red}permission denied${reset}"
fi

