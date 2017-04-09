#!/bin/bash

source ~/.script/color.conf 2> /dev/null


DEV_LIB_PATH=~/.develop/lib
lib=lib$1.a


if [ "$1" == "--help" ]
then
	echo -e "\nTwo arguments required:"
	echo -e "\t1 ${orange}name of static library${reset}"
	echo -e "\t2 ${orange}path where copies library${reset} (optional)"
	echo -e "\t  if path is void it was copied in the current directory\n"
	exit 0
fi


[ "$2" != "" ] && TO="$2" || TO="."


if [ -d $DEV_LIB_PATH/$lib ]
then
	echo -e "${green}"
	cp -v $DEV_LIB_PATH/$lib $TO
	echo -e "${reset}"

else
	echo "$lib ${red}not found${reset}"
	exit 1
fi


