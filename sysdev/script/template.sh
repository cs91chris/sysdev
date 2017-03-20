#!/bin/bash

source ~/.script/color.conf 2> /dev/null


if [ "$1" == "--help" ]
then
	echo -e "this script required 2 argument:"
	echo -e "\t1 file ${orange}model${reset}"
	echo -e "\t2 file ${orange}name${reset} (optional)"
	exit 0
fi


FILE=""
MODEL=$1
NAME=$2
MODELS=~/Models
[ "$2" == "" ] && NAME=$1


echo -e "${green}"

for d in $(ls $MODELS)
do
	if [ -f $MODELS/$d/$MODEL.* ]; then
		FILE=$NAME.$MODEL
		cp -v $MODELS/$d/$MODEL.* $FILE
		break

	elif [ -f $MODELS/$d/$MODEL ]; then
		FILE=$NAME
		cp -v $MODELS/$d/$MODEL $FILE
		break
	fi
done

sleep 0.5s
echo -e "${reset}"


[ "$FILE" != "" ] && $EDITOR $FILE || {
	echo -e "template $MODEL does ${red}not exist${reset}!"
	exit 1
}

