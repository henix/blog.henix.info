#!/bin/sh

# name title catid catname publish_time postPath tagPath rela_path

echo "{
	name = '$(cat $1)',
	title = $(cat $2 | ./escape.lua),
	catid = '$(cat $3)',
	catname = $(cat $4 | ./escape.lua),
	publish_time = $(cat $5),
	comment_count = 0,
	post_path = '$6',
	tags_path = '$7',
	rela_path = '$8',
}"
