#!/bin/bash

source ~/sysdevScript/color.conf 2> /dev/null


if [ $1 == "add" ]; then
	if [ -f ./$2 ]; then
		mv ./$2 ~/sysdevModels
	else
		vim +w ~/sysdevModels/$2
	fi
	exit 0
fi

if [ -f ~/sysdevModels/$1.$1 ]; then
	cp ~/sysdevModels/$1.$1 ./$2.$1
<<<<<<< HEAD
    vim ./$2
=======
	vim $2.$1
>>>>>>> ae3ca0e51e4865a2124950606e374b8024240b43

else
	if [ -f ~/sysdevModels/$1 ]; then
		cp ~/sysdevModels/$1 ./$2
<<<<<<< HEAD
        vim ./$2
=======
		vim $2
>>>>>>> ae3ca0e51e4865a2124950606e374b8024240b43

	else
		echo -e "template does ${red}not exist${reset}!"
	fi
fi

