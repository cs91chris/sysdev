#!/bin/bash

source sysdev/Script/color.conf


LOG_FILE=~/.sysdev.log

conf_file=(	.config/htop/htoprc .config/ranger/rc.conf .config/python
	.profile 		.bash_conf 		.bash_logout
	.bash_profile	.bashrc 		.vim
	Models			Develop 		Script
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
	cd ~ > /dev/null
	if [ ! -e ~/.conf.old.tar ]; then
		echo -e "${green}archive${reset} old configuration files"

		tar --create -f .conf.old.tar \
			--atime-preserve --numeric-owner --preserve-permissions \
			--absolute-names --same-owner 	 --ignore-failed-read \
			${conf_file[@]} 2> $LOG_FILE
	fi
	rm -rf ${conf_file[@]}
	cd - > /dev/null

    echo -e "${green}templates${reset} directory installed"
	echo -e "${green}scripts${reset} directory installed"

	cp -r sysdev/Models ~
	cp -r sysdev/Script ~
	chmod -R +x ~/Script

	echo -e "${green}develop's${reset} directories created"

	mkdir -v ~/Bin
	mkdir -v ~/Develop
	mkdir -v ~/Develop/lib
	mkdir -v ~/Develop/include

	echo -e "\n${green}installing${reset} configuration files:"
	echo -e "\n${orange}bash${reset} configuration"

	cp -v sysdev/profile ~/.profile
	cp -v sysdev/bashrc ~/.bashrc
	cp -v sysdev/bash_logout ~/.bash_logout
	cp -r sysdev/bash_conf ~
	mv ~/bash_conf ~/.bash_conf

	echo -e "${orange}ranger${reset} configuration"
	echo -e "${orange}htop${reset} configuration"
	echo -e "${orange}python${reset} configuration"

	mkdir ~/.config/ranger
	mkdir ~/.config/htop

	cp -v sysdev/config/ranger/rc.conf ~/.config/ranger/rc.conf
	cp -v sysdev/config/htop/htoprc ~/.config/htop/htoprc
	cp -vR sysdev/config/python/ ~/.config/python/

	echo -e "\n${orange}vim${reset} configuration"

	cp -r sysdev/vim ~
	mv ~/vim ~/.vim

	echo -e "${green}installation${reset} plugins..."

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 2> $LOG_FILE
	vim +PluginInstall +qall 2> $LOG_FILE
	echo "colorscheme thor" >> ~/.vim/vimrc
fi

#===============================================================================

if [ $1 == "restore" ]; then
	if [ -f ~/.conf.old.tar ]; then
		echo -e "${green}deleting${reset} new configuration files..."
	
		cd ~ > /dev/null
		rm -rf ${conf_file[@]} 2> $LOG_FILE

		echo -e "${green}restoring${reset} old configuration files"

		tar -xf .conf.old.tar 2> $LOGFILE
		rm -v .conf.old.tar

	else
		echo -e "old configuration files does ${red}not exists${reset}"
		exit 1
	fi
fi

