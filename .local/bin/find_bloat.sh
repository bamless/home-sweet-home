#!/bin/bash

# Visit all diretories in the current $PWD printing them if they exceed the 
# provided size threshold. The threshold is interpreted as megabytes.

size_tresh="20"

if [ $# -ne 0 ]; then
	case $1 in
		''|*[!0-9]*)
			>&2 echo "Usage: ${0} [size-treshold (MB)]"
			exit -1
			;;
		*)
			size_tresh=$1
			;;
	esac
fi

du -h | awk --use-lc-numeric "
	\$1 ~ /[MGK]/ {
		size = substr(\$1, 0, length(\$1) - 1) + 0.0;
		unit = substr(\$1, length(\$1), length(\$1));
		
		switch(unit) {
		case \"G\":
			size *= 1024;
			break;
		case \"K\":
			size /= 1024;
			break;
		case \"\":
			size /= 1024 * 1024;
			break;
		}

		if(size > ${size_tresh}) {
			print \$0;
		}
	}
"
