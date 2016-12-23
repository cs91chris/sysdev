#!/bin/bash

source sysdev/Script/color.conf

SYSDEV_PATH=sysdev
LOG_FILE=~/.sysdev.log

REPO_SPEEDTEST=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git 


if [ $1 == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}\n"
	echo -e "first run ${orange}./install-tools${reset} then:"
	echo -e "./sysdev.sh: for installing sysdev configuration"
	exit 0
fi

#===============================================================================

echo -e "${green}templates${reset} directory installed"
echo -e "${green}scripts${reset} directory installed"

mkdir ~/Bin ~/Develop/{lib,include}
cp -r $SYSDEV_PATH/Models ~
cp -r $SYSDEV_PATH/Script ~
cd ~/Script > /dev/null 

wget -O speedtest-cli $REPO_SPEEDTEST 2> $LOG_FILE
chmod -R +x ~/Script
cd - > /dev/null

echo -e "\n${green}installing${reset} cheatsheets"
cp -v -r $SYSDEV_PATH/sys-cheat ~/.cheat

echo -e "\n${green}installing${reset} configuration files:"
echo -e "\n${orange}bash${reset} configuration"

cp -v $SYSDEV_PATH/profile ~/.profile
cp -v $SYSDEV_PATH/bashrc ~/.bashrc
cp -v $SYSDEV_PATH/bash_logout ~/.bash_logout
cp -r $SYSDEV_PATH/bash_conf ~/.bash_conf

echo -e "${orange}ranger${reset} configuration"
echo -e "${orange}htop${reset} configuration"
echo -e "${orange}python${reset} configuration"

mkdir ~/.config
cp -v -r $SYSDEV_PATH/config/* ~/.config

echo -e "\n${orange}vim${reset} configuration"
cp -r $SYSDEV_PATH/vim ~/.vim

echo -e "${green}installation${reset} plugins..."
git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim 2> $LOG_FILE
vim +PluginInstall +qall 2> $LOG_FILE
echo "colorscheme thor" >> ~/.vim/vimrc

