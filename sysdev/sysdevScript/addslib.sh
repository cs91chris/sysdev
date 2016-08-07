#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


lib=lib$1.a

if [ -f ~/develop/$lib ]
	then
		cp -v ~/develop/$lib $2
	else
		echo "$lib does ${red}not exist${reset}"
fi

