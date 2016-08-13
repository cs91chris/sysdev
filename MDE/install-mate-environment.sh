#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $(id -u) -eq 0 ]; then
		apt-get update

		# basic environment
		apt-get install \
			lightdm mate-desktop-environment network-manager-gnome

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
			dia vlc gpaint bleachbit fslint

		cp -i user-dirs.dirs ~/.config
		cp -i -R themes ~
		mv ~/themes ~/.themes

		mkdir -v ~/Desktop
		mkdir -v ~/Documents
		mkdir -v ~/Download
		mkdir -v ~/Pictures
		mkdir -v ~/Public
		mkdir -v ~/Music
		mkdir -v ~/Videos

	else
		echo -e "you are not root: ${red}permission denied${reset}"
		exit 1
fi

