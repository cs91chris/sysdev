#!/bin/bash

if [ -f ~/Models/*.$1 ]
	then
		cp ~/Models/$1 ./$2
		echo -e "$2 created"

	else if [ -f ~/Models/$1 ]
			then
				cp ~/Models/$1 ./$2
				echo -e "$2 created"
		else
			echo -e "template does not exist!"

		fi
fi

