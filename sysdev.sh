#!/bin/bash

source sysdev/script/color.conf

conf_file=(
	Models			develop
	.profile 		.bash_conf 
	.bash_logout 	.bash_profile
	.script 		.config/htop
	.vim			.config/ranger
)

#===============================================================================

if [ $1 == "help" ]; then
	echo -e "author: ${orange}Christian Sannino${reset}"
	echo -e "released under ${orange}GPL v3 license${reset}"
	echo
	echo -e "./sysdev.sh ${green}help${reset}: for this information"
	echo -e "./sysdev.sh ${green}install${reset}: for installing sysdev configuration"
	echo -e "./sysdev.sh ${green}restore${reset}: for restoring the last configuration"

	exit 0
fi

#===============================================================================

if [ $1 == "install" ]; then

	if [ -f ~/.conf.old.tar ]; then
		echo -e "${red}"
		rm -i ~/.conf.old.tar &&
		echo -e "\n${reset}old archive removed"
	fi

	cd ~ > /dev/null

	echo -e "${green}archive${reset} old configuration files"
	tar --create -f .conf.old.tar .bashrc

	for element in $(seq 0 $((${#conf_file[@]} - 1))); do
		if [ -f ${conf_file[$element]} ]; then
			tar --append -f .conf.old.tar ${conf_file[$element]}
		fi
	done

	#===============================================================================

	cd - > /dev/null

	echo -e "${green}templates${reset} copied"
	echo -e "${green}scripts${reset} copied"

	cp --recursive sysdev/Models ~
	cp --recursive sysdev/script ~/.script && chmod -R +x ~/.script

	if [ ! -d ~/develop ]; then
		echo -e "${green}develop${reset} dir created"
		mkdir ~/develop
		mkdir ~/develop/lib
		mkdir ~/develop/include
	fi

	#===============================================================================

	echo -e "\n${green}copying${reset} configuration files:"
	echo -e "${orange}bash conf.${reset}"
	echo -e "${orange}ranger conf.${reset}"
	echo -e "${orange}htop conf.${reset}"

	cp sysdev/bashrc  ~/.bashrc
	cp sysdev/profile ~/.profile
	cp sysdev/bash_logout ~/.bash_logout
	cp --recursive sysdev/bash_conf/ ~/.bash_conf
	cp sysdev/config/ranger/rc.conf ~/.config/rc.conf
	cp sysdev/config/htop/htoprc ~/.config/htop/htoprc

	echo -e "${orange}vim conf.${reset}"
	rm -rf ~/.vim && mkdir ~/.vim
	cp --recursive sysdev/vim ~/.vim

	echo -e "${green}installation${reset} plugins..."
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi

#===============================================================================

if [ $1 == "restore" ]; then
	if [ -f ~/.conf.old.tar ]; then
		cd ~ > /dev/null

		for element in $(seq 0 $((${#conf_file[@]} - 1))); do
			if [ -f ${conf_file[$element]} ]; then
				rm -rf ${conf_file[$element]}
			fi
		done

	#===============================================================================

		echo -e "${green}overwrite${reset} new configuration files..."
		tar --extract --overwrite -f .conf.old.tar
		cd - > /dev/null
		echo -e "old configuration files ${green}restored${reset}!"

	else
		echo -e "${red}old${reset} configuration does not exist"
	fi
fi

