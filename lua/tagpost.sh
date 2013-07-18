#!/bin/sh

[ $# -ne 3 ] && echo Usage: tagpost.sh tagsfile namefile timefile && exit 1

tmp=$(mktemp)
nlines=$(wc -l $1 | cut -d ' ' -f 1)
yes "$(cat $2)	$(cat $3)" | head -n $nlines > $tmp
paste $1 $tmp
rm $tmp
