#!/bin/bash

# required <FILE_NAME> as parameter
# 	<FILE_NAME> is the name of the log file
# 	and not needed extension
#
# use function WRITE_LOG in your scripts as follow:
#
#	WRITE_LOG <type> <message>
#
#	type: INFO, WARN, ERROR, DEBUG
#

FILE_NAME=$1
DAY=$(date +"%Y%m%d")

export INFO="INFO"
export WARN="WARN"
export ERROR="ERROR"
export DEBUG="DEBUG"

export FILE_LOG=~/.log/${FILE_NAME}_$DAY.log


WRITE_LOG()
{
	type=$1
	message=$2
	curr_date=$(date "+%T %F")

	[[ "$type" != "" && "$message" != "" ]] && {
		echo -e "[$curr_date][$type]: $message" >> $FILE_LOG
	}
}

