#!/bin/bash

set +o noclobber
source sysdev/script/color.conf

error=0
FILE_LOG=~/.sysdev.log

REPO_SPEEDTEST=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git 


if [ "$1" == "--help" ]; then
	echo -e "\nAuthor: ${green}Christian Sannino${reset}"
	echo -e "Released under ${green}GPL v3 license${reset}\n"
	echo -e "First run ${orange}./install-tools${reset} then:"
	echo -e "${orange}./sysdev.sh${reset}: for installing sysdev configuration"
	echo -e "In case of error see ${orange}~/.sysdev.log${reset}\n"
	exit 0
fi

#===============================================================================


echo -e "${red}Warning${reset}: this will destroy configuration files in your home!"
echo -e "Do you want continue? [y/N]: " ; read -r ANS

case "$ANS" in
	y*|Y*)		;;
	s*|S*)		;;
	*) exit 1 	;;
esac


echo -e "${orange}Copying${reset} configurations..."

cd sysdev > /dev/null
for x in $(ls)
do
	[ -d ~/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp ~/.$x &>> $FILE_LOG
	[ $? -ne 0 ] && error=1
done
cd - > /dev/null


echo -e "${orange}Copying${reset} scripts..."

cd ~/.script > /dev/null
if [ ! -f speedtest-cli ]
then
	wget -O speedtest-cli $REPO_SPEEDTEST &>> $FILE_LOG
	[ $? -ne 0 ] && error=1
fi
cd - > /dev/null


if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
	echo -e "${orange}Setting vim${reset} configurations..."
	git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim &>> $FILE_LOG
	[ $? -ne 0 ] && error=1

	vim +PluginInstall +qall 2>> $FILE_LOG
	[ $? -ne 0 ] && error=1
	echo "colorscheme thor" >> ~/.vim/vimrc
fi


if [ $error -eq 1 ]
then
	msg_color=red
	msg_text="something went wrong see ~/.sysdev.log"
else
	msg_color=green
	msg_text="ALL DONE"
fi

echo -e "${$msg_color}$msg_text!${reset} "
cd - > /dev/null

