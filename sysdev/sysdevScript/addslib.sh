#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


lib=lib$1.a

if [ -f ~/sysdevDevelop/$lib ]
	then
		cp -v ~/sysdevDevelop/$lib $2
	else
		echo "$lib does ${red}not exist${reset}"
        exit 1
fi

