#!/bin/bash

source sysdev/sysdevScript/color.conf

conf_file=(
	.config/htop/htoprc .config/ranger/rc.conf
	.profile 		.bash_conf 	.bash_logout
	.bash_profile	.vim
	sysdevModels	sysdevDevelop .sysdevScript
)

#===============================================================================

if [ $1 == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}\n"
	echo -e "./sysdev.sh ${green}help${reset}: for this information"
	echo -e "./sysdev.sh ${green}install${reset}: for installing sysdev configuration"
	echo -e "./sysdev.sh ${green}restore${reset}: for restoring the old configuration"

	exit 0
fi

#===============================================================================

if [ $1 == "install" ]; then

	if [ ! -e ~/.conf.old.tar ]; then
		cd ~ > /dev/null

		echo -e "${green}archive${reset} old configuration files"
		tar --create -af .conf.old.tar .bashrc

		for element in $(seq 0 $((${#conf_file[@]} - 1))); do
			if [ -f ${conf_file[$element]} ]; then
				tar --append -f .conf.old.tar ${conf_file[$element]}
			fi
		done
		cd - > /dev/null
	fi

	echo -e "${green}templates${reset} directory installed"
	echo -e "${green}scripts${reset} directory installed"

	cp -r sysdev/sysdevModels ~
	mkdir ~/.sysdevScript 2> /dev/null
	cp sysdev/sysdevScript/* ~/.sysdevScript
	chmod -R +x ~/.sysdevScript

	echo -e "${green}develop's${reset} directories created"
	mkdir ~/sysdevDevelop 2> /dev/null
	mkdir ~/sysdevDevelop/lib 2> /dev/null
	mkdir ~/sysdevDevelop/include 2> /dev/null

	echo
	echo -e "${green}installing${reset} configuration files:"
	echo -e "${orange}bash${reset} configuration"
	echo -e "${orange}ranger${reset} configuration"
	echo -e "${orange}htop${reset} configuration"

	mkdir .bash_conf 2> /dev/null
	cp sysdev/bash_conf/* ~/.bash_conf

	cp sysdev/bashrc  ~/.bashrc
	cp sysdev/profile ~/.profile
	cp sysdev/bash_logout ~/.bash_logout

	cp sysdev/config/ranger/rc.conf ~/.config/ranger/rc.conf
	cp sysdev/config/htop/htoprc ~/.config/htop/htoprc

	echo -e "${orange}vim conf.${reset}"
	cp sysdev/vim/* ~/.vim 2> /dev/null

	echo -e "${green}installation${reset} plugins..."
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 2> /dev/null
	vim +PluginUpdate +PluginInstall +qall
fi

#===============================================================================

if [ $1 == "restore" ]; then
	if [ -f ~/.conf.old.tar ]; then
		echo -e "${green}deleting${reset} new configuration files..."
		cd ~ > /dev/null

		for element in $(seq 0 $((${#conf_file[@]} - 1))); do
			if [ -f ${conf_file[$element]} ]; then
				rm -rf ${conf_file[$element]}
			fi
		done
		cd - > /dev/null

		echo -e "${green}restoring${reset} old configuration files"
		tar --extract -f ~/.conf.old.tar
		rm ~/.conf.old.tar

	else
		echo -e "old configuration files does ${red}not exists${reset}"
	fi
fi

