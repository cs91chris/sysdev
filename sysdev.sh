#!/bin/bash

set +o noclobber
source sysdev/script/color.conf

ERR_EXIT=0
FILE_LOG=$HOME/.sysdev.log

REPO_SPEEDTEST=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git 


if [ "$1" == "--help" ]; then
	echo -e "\nAuthor: ${green}Cs91chris${reset}"
	echo -e "Released under ${green}GPL v3 license${reset}\n"
	echo -e "First run ${orange}./install-tools${reset} then:"
	echo -e "${orange}./sysdev.sh${reset}: for installing sysdev configuration"
	echo -e "In case of error see ${orange}$FILE_LOG${reset}\n"
	exit 0
fi

#===============================================================================


echo -e "${red}Warning${reset}: this will destroy configuration files in your home!"
echo -e "Do you want continue? [y/N]: " ; read -r ANS

case "$ANS" in
	y*|Y*)    ;;
	*) exit 1 ;;
esac


echo -e "${orange}Copying${reset} configurations..."

cd sysdev > /dev/null
for x in $(ls)
do
	[ -d ~/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp ~/.$x &>> $FILE_LOG || ERR_EXIT=1
done
cd - > /dev/null


echo -e "${orange}Copying${reset} scripts..."
cd ~/.script > /dev/null

if [ ! -f speedtest-cli ] ; then
	wget -O speedtest-cli $REPO_SPEEDTEST 2>> $FILE_LOG > /dev/null || ERR_EXIT=1
fi

chmod +x *
cd - > /dev/null


if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
	echo -e "${orange}Setting vim${reset} configurations..."
	git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim &>> $FILE_LOG || ERR_EXIT=1

	vim +PluginInstall +qall 2>> $FILE_LOG > /dev/null || ERR_EXIT=1
	echo "colorscheme thor" >> ~/.vim/vimrc
fi


if [ $ERR_EXIT -eq 1 ]
then
	echo -e "${red}"
	msg_text="something went wrong see $FILE_LOG"
else
	echo -e "${green}"
	msg_text="ALL DONE"
fi

echo -e "$msg_text!${reset} "
cd - > /dev/null
exit $ERR_EXIT
