#!/bin/bash

set +o noclobber
source sysdev_setenv.sh


ENABLED_SYS=0
ENABLED_DEV=0


INSTALL_TOOLS()
{
	TYPE=$1
	TOOLS=$2

	echo -e "$INSTALLING $TYPE..."

	for p in $TOOLS
	do
		if ! dpkg -s $p &> /dev/null 
		then
			sudo apt install $p -y &>> $INSTALL_LOG
			[ $? -eq 0] && echo $p >> $TOOLS_INSTALLED
		fi
	done
}


#_________________________________________________________________________________________
#

for opt in "$@"
do
	case $opt in
		-h | --help)
			cat README
			exit 0
		;;

		-s | --sys)	ENABLED_SYS=1 ;;
		-d | --dev)	ENABLED_DEV=1 ;;

		*)
			echo -e "Option ${red}'$opt'${reset} not valid!"
			exit 1
		;;
	esac
done


if [[ -x $(which apt) && -x $(which dpkg) ]]
then
	sudo apt update &>> $INSTALL_LOG

	if [ $? -eq 0 ]
	then
		INSTALL_TOOLS "needed tools" "$TOOLS_NEEDED"

		if [ $ENABLED_SYS -eq 1 ] ; then
			INSTALL_TOOLS "system tools" "$TOOLS_SYS"
		fi

		if [ $ENABLED_DEV -eq 1 ] ; then
			INSTALL_TOOLS "develop tools" "$TOOLS_DEV"
		fi
	fi

	if [ ! $(which cheat) ]
	then
		echo -e "$INSTALLING cheat..."
		git clone $CHEAT_REPO &>> $INSTALL_LOG

		if [ $? -eq 0 ]
		then
			cd cheat > /dev/null
			sudo make install &>> $INSTALL_LOG
			sudo chmod -R 755 $CHEAT_PATH
			cd - > /dev/null
		fi

		rm -rf cheat &>> $INSTALL_LOG
	fi
fi


# XXX TODO FIXME
#
echo -e "$COPYING configurations..."

cd sysdev > /dev/null
for x in $(ls)
do
	[ -d ~/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp ~/.$x &>> $INSTALL_LOG
	[ CHECK_ERROR $? -eq 0 ] && echo -e "\t$COPYING $tmp"
done
cd - > /dev/null


if [ ! -f ~/.script/speedtest-cli ]
then
	cd ~/.script > /dev/null
	wget -O speedtest-cli $REPO_SPEEDTEST 2>> $INSTALL_LOG > /dev/null
	CHECK_ERROR $?
	cd - > /dev/null
fi


if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
	echo -e "$INSTALLING vim configurations..."
	git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim &>> $INSTALL_LOG
	CHECK_ERROR $?

	vim +PluginInstall +qall 2>> $INSTALL_LOG > /dev/null
	CHECK_ERROR $?
	echo "colorscheme thor" >> ~/.vim/vimrc
fi


CHECK_STATUS_ON_EXIT


