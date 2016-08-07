#!/bin/bash

source ~/sysdevScript/color.conf


lib=lib$1.a

if [ -f ~/develop/$lib ]
	then
		cp -v ~/develop/$lib $2
	else
		echo "$lib does ${red}not exist${reset}"
fi

