#!/bin/bash

source ~/Script/color.conf 2> /dev/null

DEV_LIB_PAT=~/Develop/lib

if [ "$1" == "--help" ]
then
	echo "this script required 2 arguments:"
	echo "\t1 ${orange}name of static library${reset}"
	echo "\t2 ${orange}path where copies library${reset} (optional)"
	exit 0
fi


lib=lib$1.a
[ "$2" != "" ] && TO="$2" || TO="."


if [ -f $DEV_LIB_PAT/$lib ]
then
	echo -e "${green}"
	cp -v $DEV_LIB_PAT/$lib $TO
	echo -e "${reset}"

else
	echo "~/Develop/lib/$lib does ${red}not exist${reset}"
	exit 1
fi


