#!/bin/bash

set +o noclobber
SYSDEV_DIR=$(dirname "$0")
source $SYSDEV_DIR/sysdev/develop/include/bash/color.conf

ERR_EXIT=0
FILE_LOG=$HOME/.log/sysdev.log

REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git


mkdir -p $HOME/{.log, .bin}


if [[ $1 == "--help" ]]; then
	cat $SYSDEV_DIR/README.md
	echo -e "In case of error see ${orange}$FILE_LOG${reset}\n"
	exit 0
fi

echo -e "${red}Warning${reset}: this will destroy configuration files in your home!"
echo -e "Do you want continue? [y/N]: " ; read -r ANS

case "$ANS" in
	y*|Y*)    ;;
	*) exit 1 ;;
esac


echo -e "${orange}Installing${reset} configurations..."

cd $SYSDEV_DIR/sysdev > /dev/null
for x in $(ls)
do
	[ -d $HOME/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp $HOME/.$x &>> $FILE_LOG || ERR_EXIT=1
done
cd - > /dev/null
ranger --copy-config=scope

ranger --copy-config=scope &>> $FILE_LOG


echo -e "${orange}Installing${reset} scripts..."
curl https://cheat.sh/:bash_completion > $HOME/.bash_conf/cht_completion
curl https://cht.sh/:cht.sh > $HOME/.script/cht

chmod +x $HOME/.script/*


if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
	echo -e "${orange}Setting vim${reset} configurations..."
	git clone $REPO_VUNDLE $HOME/.vim/bundle/Vundle.vim 2>> $FILE_LOG && {
        vim +PluginInstall +qall 2>> $FILE_LOG || ERR_EXIT=1
        echo "colorscheme thor" >> $HOME/.vim/vimrc
    } || ERR_EXIT=1
else
    cd $HOME/.vim/bundle/Vundle.vim > /dev/null
    git pull 2>> $FILE_LOG && {
        vim +PluginUpdate +qall 2>> $FILE_LOG || ERR_EXIT=1
    }
    cd - > /dev/null
fi


if [[ $ERR_EXIT -eq 1 ]]
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
