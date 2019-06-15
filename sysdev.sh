#!/bin/bash

set +o noclobber
SYSDEV_DIR=$(dirname "$0")
source $SYSDEV_DIR/sysdev/develop/bash/color.conf

ERR_EXIT=0
FILE_LOG=$HOME/.log/sysdev.log

REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git


if [[ $1 == "--help" ]]; then
	cat $SYSDEV_DIR/README.md
	echo -e "In case of error see ${orange}$FILE_LOG${reset}\n"
	exit 0
fi

echo -e "${red}Warning${reset}: this will replace configuration files in your home!"
read -p "Do you want continue? [yes/N]: " -r ANS

case "$ANS" in
	yes)      ;;
	*) exit 1 ;;
esac


echo -e "${orange}Installing${reset} configurations..."
mkdir -p $HOME/{.log,.bin}

cd $SYSDEV_DIR/sysdev > /dev/null
for x in $(ls)
do
	[ -d $HOME/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp $HOME/.$x &>> $FILE_LOG || ERR_EXIT=1
done
cd - > /dev/null

ranger --copy-config=scope &>> $FILE_LOG


echo -e "${orange}Installing${reset} scripts..."
curl -s https://cheat.sh/:bash_completion > $HOME/.bash_conf/cht_completion
curl -s https://cht.sh/:cht.sh > $HOME/.script/cht

chmod +x $HOME/{.script,.bin}/* >> $FILE_LOG 2>&1


echo -e "${orange}Setting vim${reset} configurations..."
rm -vrf $REPO_VUNDLE $HOME/.vim/bundle/Vundle.vim >> $FILE_LOG 
git clone $REPO_VUNDLE $HOME/.vim/bundle/Vundle.vim 2>> $FILE_LOG || ERR_EXIT=1
vim +PluginInstall +qall >> $FILE_LOG 2>&1 || ERR_EXIT=1

echo -e "${orange}Installing tmux${reset} configuration..."

git clone https://github.com/gpakosz/.tmux.git >> $FILE_LOG 2>&1 && {
    cp .tmux/.tmux.conf $HOME
    cp .tmux/.tmux.conf.local $HOME
    rm -rf .tmux
} || ERR_EXIT=1


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
