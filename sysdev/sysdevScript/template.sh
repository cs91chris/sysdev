#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ -f ~/sysdevModels/$1.$1 ]; then
	cp ~/sysdevModels/$1.$1 ./$2.$1
	echo -e "$2 ${green}created${reset}"

else
	if [ -f ~/sysdevModels/$1 ]; then
		cp ~/sysdevModels/$1 ./$2
		echo -e "$2 ${green}created${reset}"

	else
		echo -e "template does ${red}not exist${reset}!"
	fi
fi

