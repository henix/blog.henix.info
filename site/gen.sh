#!/bin/sh
for cat in tips security devtools program web ; do
	for i in $(find $cat -mindepth 1 -maxdepth 1 -type d); do
		cd "$i"
		make -s -f ../../blog.mk
		cd ../..
	done
done

make
