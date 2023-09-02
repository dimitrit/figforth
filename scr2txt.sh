#! /bin/sh
#
# Convert screens file to text
#
fold -b64 $1 | nawk '{ l=(NR-1) % 16; if (l==0) printf "\nSCR#%d\n",s++;printf "%3d %s\n",l,$0 }' 
