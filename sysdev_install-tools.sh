#!/bin/bash


[[ ! -x $(which apt) || ! -x $(which dpkg) ]] && exit 1


EN_SYS=$1
EN_DEV=$2


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


INSTALL_TOOLS()
{
	TOOLS=$1

	for p in $TOOLS
	do
		if ! dpkg -s $p &> /dev/null 
		then
			sudo apt install $p -y &>> $FILE_LOG

			if CHECK_ERROR $? ; then
				echo $P >> $LOG_INSTALLED
			fi
		fi
	done
}

sudo apt update &>> $FILE_LOG

if [ CHECK_ERROR $? -eq 0 ]
then
	# needed tools
	INSTALL_TOOLS "$TOOLS_NEEDED"
	
	# system tools
	[ $EN_SYS -eq 1 ] && INSTALL_TOOLS "$TOOLS_SYS"

	# develop tools
	[ $EN_DEV -eq 1 ] && INSTALL_TOOLS "$TOOLS_DEV"
fi


if [ ! $(which cheat) ]
then
	echo -e "$INSTALLING cheat..."
	git clone $CHEAT_REPO &>> $FILE_LOG

	if CHECK_ERROR $?
	then
		cd cheat > /dev/null
		sudo make install &>> $FILE_LOG
		sudo chmod -R 755 $CHEAT_PATH
		cd - > /dev/null
	fi

	rm -rf cheat &>> $FILE_LOG
fi


CHECK_STATUS_ON_EXIT

