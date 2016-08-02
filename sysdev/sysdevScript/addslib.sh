#!/bin/bash

lib=lib$1.a

if [ -f ~/develop/$lib ]
	then
		cp -v ~/develop/$lib $2
	else
		echo "$lib does not exist"
fi

