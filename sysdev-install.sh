#!/bin/bash

source sysdev/script/color.conf

# fix this path if does not work
dir_ranger_conf=/usr/lib/python2.7/dist-packages/ranger/config/ 

conf_file=(
	.profile 		.bash_conf 
	.bash_logout 	.bash_profile
	.script 		.config/htop
	.vim 			${dir_ranger_conf}
)

#===============================================================================

if [ -f ~/.conf.old.tar ]; then
	echo -e "${red}"
	rm -i ~/.conf.old.tar &&
	echo -e "\n${reset}old archive removed"
fi

cd ~ > /dev/null

echo -e "${green}archive${reset} old configuration files"
tar --create -f ~/.conf.old.tar .bashrc

for element in $(seq 0 $((${#conf_file[@]} - 1))); do
	if [ -f ${conf_file[$element]} ]; then
		tar --append -f .conf.old.tar ${conf_file[$element]}
	fi
done

cd - > /dev/null

#===============================================================================

echo -e "${green}templates${reset} copied"
cp --recursive sysdev/Models ~

echo -e "${green}scripts${reset} copied"
cp sysdev/script/* ~/.script/ && chmod -R +x ~/.script/

if [ ! -d ~/develop ]; then
	echo -e "${green}develop${reset} dir created"
	mkdir ~/develop
	mkdir ~/develop/lib
	mkdir ~/develop/include
fi

#===============================================================================

echo -e "\n${green}copying${reset} configuration files:"
echo -e "${orange}bash conf.${reset}"
cp sysdev/bashrc  ~/.bashrc
cp sysdev/profile ~/.profile
cp sysdev/bash_logout ~/.bash_logout
cp sysdev/bash_conf/* ~/.bash_conf

echo -e "${orange}ranger conf.${reset}"
sudo cp sysdev/config/ranger/rc.conf ${dir_ranger_conf}

echo -e "${orange}htop conf.${reset}"
cp sysdev/config/htop/htoprc ~/.config/htop/htoprc

echo -e "${orange}vim conf.${reset}"
rm -rf ~/.vim && mkdir ~/.vim
cp sysdev/vim/* ~/.vim

echo -e "${orange}installation plugins...${reset}"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


