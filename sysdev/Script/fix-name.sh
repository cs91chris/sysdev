#!/bin/bash

ls | while read -r FILE
do
	mv -v "$FILE" `echo $FILE 	| \
	tr ' ' '-' 					| \
	tr -d '[{}(),\!]' 			| \
	tr -d "\'" 					| \
	tr '[A-Z]' '[a-z]' 			| \
	sed 's/_-_/_/g'` 2> /dev/null
done

