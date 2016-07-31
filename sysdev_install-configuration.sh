#!/bin/bash


set +o noclobber


if [ "$1" == "--help" ]
then
	PRINT_AUTHOR_LICENSE
	echo -e "In case of error $SEE_FILE_LOG"
	exit 0
fi


echo -e "${red}Warning${reset}: this will destroy configuration files in your home!"
[ ! QUESTION "Do you want continue?" ] && exit 1


echo -e "$COPYING configurations..."

cd sysdev > /dev/null
for x in $(ls)
do
	[ -d ~/.$x ] && tmp="$x/*" || tmp="$x" 
	cp --verbose --recursive $tmp ~/.$x &>> $FILE_LOG
	[ CHECK_ERROR $? -eq 0 ] && echo -e "\t$COPYING $tmp"
done
cd - > /dev/null


if [[ -d ~/.script && ! -f ~/.script/speedtest-cli ]]
then
	cd ~/.script > /dev/null
	wget -O speedtest-cli $REPO_SPEEDTEST 2>> $FILE_LOG > /dev/null
	CHECK_ERROR $?
	cd - > /dev/null
fi


if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
	echo -e "$INSTALLING vim configurations..."
	git clone $REPO_VUNDLE ~/.vim/bundle/Vundle.vim &>> $FILE_LOG
	CHECK_ERROR $?

	vim +PluginInstall +qall 2>> $FILE_LOG > /dev/null
	CHECK_ERROR $?
	echo "colorscheme thor" >> ~/.vim/vimrc
fi

CHECK_STATUS_ON_EXIT
cd - > /dev/null


