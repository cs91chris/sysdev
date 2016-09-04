#!/bin/bash

source ~/Script/color.conf 2> /dev/null


if [ $1 == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}\n"
	echo "this script install a minimal mate desktop environment"

	exit 0
fi


if [ $(id -u) -eq 0 ]; then
		apt-get update

		# basic environment
		apt-get install \
			gdm mate-desktop-environment network-manager-gnome

		# printer manager
		apt-get install \
			cups system-config-printer simple-scan

		# disk manager
		apt-get install \
			gparted gpart

		# internet application
		apt-get install \
	        liferea icedove firefox-esr transmission

		# other application
		apt-get install \
			dia vlc gpaint bleachbit fslint grsync gdebi hardinfo

		# libreoffice
		apt-get install \
			libreoffice libreoffice-gnome

	else
		echo -e "you are not root: ${red}permission denied${reset}"
		exit 1
fi

