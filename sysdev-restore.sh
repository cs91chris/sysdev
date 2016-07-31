#!/bin/bash

source script/color.conf

if [ -f ~/.conf.old.tar ]
	then
		cd ~ > /dev/null
		echo -e "${green}overwrite${reset} new configuration files..."
		tar --extract --overwrite -f ~/.conf.old.tar
		echo -e "old configuration files ${green}restored${reset}!"
	else
		echo -e "old configuration files does ${red}not exists${reset}!"		
fi

