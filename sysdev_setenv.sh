#!/bin/bash


source sysdev/script/color.conf


export ERROR=0
export SYSDEV_DIR=~/.sysdev
export INSTALL_LOG=~/$SYSDEV_DIR/install.log
export RESTORE_LOG=~/$SYSDEV_DIR/restore.log
export TOOLS_INSTALLED=~/$SYSDEV_DIR/tools_installed.info


export REPO_SPEEDTEST=https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
export REPO_VUNDLE=https://github.com/VundleVim/Vundle.vim.git
export REPO_CHEAT=https://github.com/jahendrie/cheat.git
export CHEAT_PATH=/usr/share/cheat/sheets


export COPYING="${green}Copying${reset}"
export INSTALLING="${green}Installing${reset}"

export SEE_FILE_LOG="See ${orange}~/.sysdev.log${reset}\n"



TOOLS_NEEDED= "
	git vim sudo
	pydf htop tree
	unrar p7zip
	figlet ranger
"

TOOLS_SYS="
	wget tmux curl
	nmap lshw
	elinks hddtemp
	tcpdump glances
	acpitool lm-sensors
	screenfetch smartmontools
"

TOOLS_DEV="
	gcc gdb g++
	indent ipython
	pyflakes colorgcc
	valgrind python-pip
"


QUESTION()
{
	MESS=$1
	echo -e "$MESS [y/N]: "
	read -r ANS

	case "$ANS" in
		y*|Y*) 	return 0 ;;
		*) 		return 1 ;;
	esac
}

CHECK_STATUS_ON_EXIT()
{
	if [ $ERROR -ne 0 ]
	then
		echo -e "${red}"
		msg_text="something went wrong $SEE_FILE_LOG"
	else
		echo -e "${green}"
		msg_text="ALL DONE"
	fi

	echo -e "$msg_text!"
	echo -e ${reset}

	exit $ERROR
}



