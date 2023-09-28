#! /bin/sh
#
# Convert text to screens file format
#
p=64
while getopts 's:h' opt; do
  case "$opt" in
    s)
      p="$OPTARG"
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-p screens]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

nawk '	BEGIN{lines=0}
	/^[ 0-9]+/ {
		gsub(/[^ -~]/,"",$0);
		gsub(/^[ ]+[0-9]+[ ]?/,"",$0);
		printf"%-64s",substr($0,0,64); lines++}
	END{
		for (i=0; i<(pages+0)-lines/16; i++) {
			for (j=0;j<16;j++) {
				printf("%-64s"," ");
			}
		}
	}' pages=${p} $1
