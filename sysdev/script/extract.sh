#!/bin/bash

source ~/.script/color.conf 2> /dev/null

FILES=$@
LOG_FILE=~/.extract.log
error=0


if [ "$1" == "--help" ]
then
	echo -e "\nArchive supported:"
	echo -e "\t${orange}zip, rar, tar, tar.xz, tar.bz2, tar.gz${reset}"
	echo -e "\t${orange}tbz2, bz2, gz, 7z, tgz, Z${reset}\n"
	exit 0
fi


for F in $FILES
do
	if [ -f $F ] ; then
		case $F in
			*.Z)			uncompress $F	2>> $LOG_FILE > /dev/null ;;
			*.7z)		7z x $F			2>> $LOG_FILE > /dev/null ;;
			*.gz)		gunzip $F		2>> $LOG_FILE > /dev/null ;;
			*.rar)		unrar x $F		2>> $LOG_FILE > /dev/null ;;
			*.zip)		unzip $F			2>> $LOG_FILE > /dev/null ;;
			*.bz2)		bunzip2 $F		2>> $LOG_FILE > /dev/null ;;
			*.tar)		tar xf $F		2>> $LOG_FILE > /dev/null ;;
			*.tgz)		tar xzf $F		2>> $LOG_FILE > /dev/null ;;
			*.tbz2)		tar xjf $F		2>> $LOG_FILE > /dev/null ;;
			*.tar.xz)	tar Jxf $F		2>> $LOG_FILE > /dev/null ;;
			*.tar.bz2)	tar xjf $F		2>> $LOG_FILE > /dev/null ;;
			*.tar.gz)	tar xzf $F		2>> $LOG_FILE > /dev/null ;;
			*)
				echo -e "'$FILE' ${red}can not be extracted${reset}"
				error=1
			;;
		esac
	else
		echo -e "'$FILE' ${red}is not a valid file${reset}!"
	    error=1
	fi

	echo -e "\t'$FILE' ${green}extracted!${reset}"
done


if [ $error -eq 1 ] ; then
	echo -e "${orange}\n\tSee $LOG_FILE${reset}"
	exit 1
else
	rm $LOG_FILE &> /dev/null
	exit 0
fi

