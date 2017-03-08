#!/bin/bash

set -o errexit
source sysdev/Script/color.conf


SYSDEV_PATH=sysdev
FILE_LOG=~/.sysdev.log

REPO_SPEEDTEST=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git 

VIM="vim"
BIN="Bin"
CHEAT="sys-cheat"
MODELS="Models"
CONFIG="config"
SCRIPT="Script"
DEVELOP="Develop"
BASH_CONF="bash_conf"

SYSDEV_DIR="\
	$BIN \
	$DEVELOP \
	$MODELS \
	$SCRIPT \
	$CONFIG \
	$CHEAT \
	$BASH_CONF \
	$VIM \
"

MAKE_DIR()
{
	DIRS=$1
	for d in $DIRS ; do
		[ ! -d $d ] && mkdir -v $d &>> $FILE_LOG
	done
}


if [ "$1" == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}\n"
	echo -e "first run ${orange}./install-tools${reset} then:"
	echo -e "${orange}./sysdev.sh${reset}: for installing sysdev configuration"
	echo -e "in case of error see ${orange}~/.sysdev.log${reset}"
	exit 0
fi


#===============================================================================


cd ~ > /dev/null

MAKE_DIR "$SYSDEV_DIR"
mkdir -p $DEVELOP/{lib,include} &>> $FILE_LOG
echo -e "${orange}Directories${reset} created"


echo -e "${orange}Copying${reset} configurations..."

cd $SYSDEV_PATH > /dev/null

for f in $(ls -l | grep ^- | awk '{print $9}') ; do
	cp -v $f ~/.$f &>> $FILE_LOG
done

cp -vr $MODELS/* 	~/$MODELS		&>> $FILE_LOG
cp -vr $SCRIPT/*	~/$SCRIPT		&>> $FILE_LOG
cp -vr $CHEAT/* 	~/.$CHEAT		&>> $FILE_LOG
cp -vr $BASH_CONF/* ~/.$BASH_CONF	&>> $FILE_LOG
cp -vr $CONFIG/* 	~/.$CONFIG		&>> $FILE_LOG
cp -vr $VIM/* 		~/.$VIM			&>> $FILE_LOG


cd - > /dev/null
cd ~/Script > /dev/null

wget -O speedtest-cli $REPO_SPEEDTEST &>> $FILE_LOG
chmod +x ~/Script/*

cd - > /dev/null


echo -e "${orange}Installing${reset} vim plugins..."
git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim &>> $LOG_FILE
vim +PluginInstall +qall 2>> $LOG_FILE
echo "colorscheme thor" >> ~/.vim/vimrc

echo -e "see ${orange}~/.sysdev.log${reset}"
cd - > /dev/null

