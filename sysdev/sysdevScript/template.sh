#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ -f ~/sysdevModels/$1.$1 ]; then
	cp ~/sysdevModels/$1.$1 ./$2.$1
	vim $2.$1

else
	if [ -f ~/sysdevModels/$1 ]; then
		cp ~/sysdevModels/$1 ./$2
		vim $2

	else
		echo -e "template does ${red}not exist${reset}!"
	fi
fi

