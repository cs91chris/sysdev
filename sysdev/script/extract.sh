#!/bin/bash

source ~/.script/color.conf 2> /dev/null

FILE=$1

if [ "$1" == "--help" ]
then
	echo "this script supports:"
	echo "\t${orange}zip, rar, tar, tar.xz, tar.bz2, tar.gz${reset}"
	echo "\t${orange}tbz2, bz2, gz, 7z, tgz, Z${reset}"
	exit 0
fi


if [ -f $FILE ]
then
	case $FILE in
		*.Z)			uncompress $FILE	;;
		*.7z)			7z x $FILE			;;
		*.gz)			gunzip $FILE		;;
		*.rar)			unrar x $FILE		;;
		*.zip)			unzip $FILE			;;
		*.bz2)			bunzip2 $FILE		;;
		*.tar)			tar xf $FILE		;;
		*.tgz)			tar xzf $FILE		;;
		*.tbz2)			tar xjf $FILE		;;
		*.tar.xz)		tar Jxf $FILE		;;
		*.tar.bz2)		tar xjf $FILE		;;
		*.tar.gz)		tar xzf $FILE		;;
		*)
			echo -e "'$FILE' ${red}can not be extracted${reset}"
			exit 1
		;;
	esac

else
	echo -e "'$FILE' ${red}is not a valid file${reset}!"
    exit 1
fi

