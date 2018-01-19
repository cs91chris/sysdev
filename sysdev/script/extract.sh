#!/bin/bash

source ~/.script/color.conf  2> /dev/null
source ~/.script/writelog.sh "extract" 2> /dev/null


FILES=$@
err_exit=0

ERR_MSG()
{
	message=$1
	err_exit=1

	if type WRITE_LOG &> /dev/null
	then
		WRITE_LOG $ERROR "$message"
	else
		echo -e "${red}$message${reset}"
	fi
}

EXTRACT()
{
	file=$1
	cmd=$2
	opt=$3

	if [ "$cmd" != "NONE" ]
	then
		mess=$($cmd $opt $file 2>&1)

		if [ $? -eq 0 ]
		then
			echo -e "\t'$file' ${green}extracted!${reset}"
		else
			ERR_MSG "$mess"
		fi
	fi
}


case $1 in
	"h" | "-h" | "help" | "--help")
		echo -e "\nArchive supported:"
		echo -e "\t${orange}zip,   rar,  tar,  tar.xz,  tar.bz2,  tar.gz${reset}"
		echo -e "\t${orange}tbz2,  bz2,  gz,   7z,      tgz,      Z${reset}\n"

		if type WRITE_LOG &> /dev/null ; then
			echo -e "In case of error see:"
			echo -e "\t${orange}$FILE_LOG${reset}\n"
		fi
		exit 0
	;;
esac

for F in $FILES
do
	if [ -f $F ] ; then
		case $F in
			*.Z) 		CMD=uncompress 	; 	OPT=""		;;
			*.7z)		CMD=7z 			; 	OPT=x		;;
			*.gz)		CMD=gunzip 		; 	OPT=""		;;
			*.rar)		CMD=unrar 		; 	OPT=x		;;
			*.zip)		CMD=unzip 		; 	OPT=""		;;
			*.bz2)		CMD=bunzip2 	; 	OPT=""		;;
			*.tar)		CMD=tar 		; 	OPT=xf		;;
			*.tgz)		CMD=tar 		; 	OPT=xzf		;;
			*.tbz2)		CMD=tar 		; 	OPT=xjf		;;
			*.tar.xz)	CMD=tar 		; 	OPT=Jxf		;;
			*.tar.bz2)	CMD=tar 		; 	OPT=xjf		;;
			*.tar.gz)	CMD=tar 		; 	OPT=xzf		;;
			*)
				CMD="NONE"
				OPT=""
				ERR_MSG "'$F' not supported"
			;;
		esac

		EXTRACT $F $CMD $OPT
	else
		ERR_MSG "'$F' is not a valid file!"
	fi
done

exit $err_exit
