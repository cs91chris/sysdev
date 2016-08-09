#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $1 == "add" ]; then
	if [ -f ./$2 ]; then
		mv ./$2 ~/sysdevModels
	else
		vim +w ~/sysdevModels/$2
	fi
	exit 0
fi

if [ -f ~/sysdevModels/$1.$1 ]; then
	cp ~/sysdevModels/$1.$1 ./$2.$1
    vim ./$2

else
	if [ -f ~/sysdevModels/$1 ]; then
		cp ~/sysdevModels/$1 ./$2
        vim ./$2

	else
		echo -e "template does ${red}not exist${reset}!"
	fi
fi

