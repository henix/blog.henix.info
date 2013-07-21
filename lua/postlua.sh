#!/bin/sh

echo "{
	name = '$(cat $1)',
	title = $(cat $2 | ./escape.lua),
	catid = '$(cat $3)',
	catname = $(cat $4 | ./escape.lua),
	publish_time = $(cat $5),
	comment_count = $(cat $6),
	post_path = '$7',
	tags_path = '$8',
	rela_path = '$9',
}"
