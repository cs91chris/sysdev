#!/bin/bash

source ~/Script/color.conf 2> /dev/null


if [ $1 == "add" ]; then
	if [ -f ./$2 ]; then
		mv ./$2 ~/Models
	else
		vim +w ~/Models/$2
	fi
	exit 0
fi

if [ -f ~/Models/$1.$1 ]; then
	cp ~/Models/$1.$1 ./$2.$1
	vim $2.$1

elif [ -f ~/Models/$1 ]; then
	cp ~/Models/$1 ./$2
	vim $2

else
	echo -e "template does ${red}not exist${reset}!"
	exit 1
fi

