#!/usr/bin/env bash
diskUsage=$(du "$1" |grep -v -G ^0)
if [ -z "$diskUsage" ]; then
	echo "$1" needs download
	exit 1
else
	echo "$1" is local available
	exit 0
fi
 
