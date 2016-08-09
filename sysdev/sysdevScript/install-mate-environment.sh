#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]; then
	apt-get update && apt-get install \
		lightdm mate-desktop-environment network-manager-gnome \
		cups system-config-printer simple-scan \
		gparted gpart \
        liferea icedove firefox-esr transmission \
		dia vlc gpaint bleachbit

	else
		echo -e "you are not root: ${red}permission denied${reset}"
fi

