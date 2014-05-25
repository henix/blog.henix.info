#!/bin/sh
for i in $(find . -mindepth 2 -maxdepth 2 -type d); do
	cd "$i"
	make -s -f ../../blog.mk
	cd ../..
done

make
