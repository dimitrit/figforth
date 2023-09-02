#! /bin/sh
#
# Convert text to screens file format
#
nawk '/^[ 0-9]+/{$1="";printf"%-64s",substr($0,length($1)+2,64)}' $1
