#! /bin/sh
#
# Convert screens file to text
#
fold -b64 $1 | sed -e 's/[ \t]*$//' 
