#!/bin/bash

source ~/Script/color.conf 2> /dev/null


lib=lib$1.a

if [ -f ~/Develop/$lib ]
	then
		cp -v ~/Develop/$lib $2
	else
		echo "$lib does ${red}not exist${reset}"
        exit 1
fi

